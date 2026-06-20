variable "tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "OCI User OCID"
  type        = string
}

variable "fingerprint" {
  description = "OCI Fingerprint"
  type        = string
}

variable "private_key_path" {
  description = "OCI Private Key Path"
  type        = string
}

variable "region" {
  description = "OCI Region"
  type        = string
}

# 1. OCI Provider 설정 (환경 변수에서 불러옴)
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}



# 2. VCN 및 네트워크 구성
resource "oci_core_vcn" "openstack_vcn" {
  compartment_id = var.tenancy_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "openstack-vcn"
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.openstack_vcn.id
  enabled        = true
}

resource "oci_core_route_table" "public_rt" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.openstack_vcn.id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id    = var.tenancy_ocid
  vcn_id            = oci_core_vcn.openstack_vcn.id
  cidr_block        = "10.0.0.0/24"
  route_table_id    = oci_core_route_table.public_rt.id
  display_name      = "openstack-public-subnet"
}

# 3. Ubuntu 22.04 LTS 이미지 데이터 소스 (동적으로 최신 이미지 검색)
data "oci_core_images" "ubuntu_2204" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E4.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# 4. Compute Instance (VM.Standard.E4.Flex) 생성
resource "oci_core_instance" "openstack_node" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.tenancy_ocid
  shape               = "VM.Standard.E4.Flex"
  display_name        = "openstack-node-01"

  shape_config {
    ocpus         = 32
    memory_in_gbs = 128
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_2204.images[0].id
    boot_volume_size_in_gbs = 200
  }

  metadata = {
    # Mac 로컬에 있는 공개키(.pub) 파일의 경로를 지정합니다.
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }
}

# 5. Secondary VNIC 부착 (Neutron External Network 용도)
resource "oci_core_vnic_attachment" "secondary_vnic" {
  instance_id = oci_core_instance.openstack_node.id
  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    display_name     = "openstack-secondary-vnic"
    assign_public_ip = false
  }
}

# 완료 후 생성된 공인 IP 출력
output "instance_public_ip" {
  value = oci_core_instance.openstack_node.public_ip
}
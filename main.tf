##
## https://ibm-cloud.github.io/tf-ibm-docs/v0.14.1/
##
variable "sl_username" {}
variable "sl_api_key" {}
variable "ic_api_key" {}

### クラスタレベルの環境設定変数
### OpenShift cluster env

variable "domain" {
  type = string
  default = "example.com"
}

variable "datacenter" {
  type = string
  default = "tok05"
}

variable "sg1" {
  type = string
  default = "130379"
  description = "allow_all"
}

variable "sg2" {
  type = string
  default = "130381"
  description = "allow_outbound"
}

### SSH鍵
variable "ssh_user" {
  type = string
  default = "root"
}
variable "ssh_label" {
  type = string
  default = "tf-node"
}
variable "ssh_notes" {
  type = string
  default = "TFで作成したインスタンス用"
}
variable "ssh_key" {}

### OSなど共通事項
variable "os_code" {
  type = string
  default = "UBUNTU_16_64"
}
variable "private_only" {
  type = string
  default = "false"
}

variable "master_node" {
  type = list(object({
    node = number
    name = string
    vcpu = number
    ram  = number
    disk = number
    nic  = number
    tag  = string    
  }))
  default = [
    {
      node = 1
      name = "master"
      vcpu = 2
      ram  = 4
      disk = 25
      nic  = 100
      tag  = "test-deploy"
    }
  ]
}

### Worker node
variable "worker_node" {
  type = list(object({
    node = number
    name = string
    vcpu = number
    ram  = number
    disk = number
    nic  = number
    tag  = string    
  }))
  default = [
    {
      node = 2
      name = "node"
      vcpu = 1
      ram  = 1
      disk = 25
      nic  = 100
      tag  = "test-deploy"
    }
  ]
}

#
# IBM Cloud のAPIキーを変数ファイルから取得する
#
# https://ibm-cloud.github.io/tf-ibm-docs/index.html
#
#provider "ibm" {
#  softlayer_username = "${var.sl_username}"
#  softlayer_api_key  = "${var.sl_api_key}"
#  bluemix_api_key    = "${var.ic_api_key}"
#}

provider "ibm" {
  #ibmcloud_api_key    = "${var.ibmcloud_api_key}"
  generation = 1
  region = "jp-tokyo"
  iaas_classic_username = "${var.sl_username}"
  iaas_classic_api_key  = "${var.sl_api_key}"
}


#
# OpenShiftクラスタ共通のssh鍵を設定する
#
# https://ibm-cloud.github.io/tf-ibm-docs/v0.14.1/d/compute_ssh_key.html
#
resource "ibm_compute_ssh_key" "ssh_key" {
  label      = "${var.ssh_label}"
  notes      = "${var.ssh_notes}"
  #public_key = "${var.ssh_key}"
  public_key = "${file("/home/vagrant/keys/key.pub")}"
}


# https://ibm-cloud.github.io/tf-ibm-docs/v0.14.1/r/compute_vm_instance.html
#
resource "ibm_compute_vm_instance" "master" {
  count                    = "${var.master_node[node]}"
  hostname                 = "${var.master_node[name]}-${count.index}"
  os_reference_code        = "${var.os_code}"
  domain                   = "${var.domain}"
  datacenter               = "${var.datacenter}"
  network_speed            = "${var.master_node[nic]}"
  hourly_billing           = true
  private_network_only     = "${var.private_only}"
  cores                    = "${var.master_node[vcpu]}"
  memory                   = "${var.master_node[ram]}"
  disks                    = ["${var.master_node[disk]}"]
  dedicated_acct_host_only = false
  local_disk               = false
  ssh_key_ids              = ["${ibm_compute_ssh_key.ssh_key.id}"]
  tags                     = ["${var.master_node[tags]}"]
  user_metadata            = "${file("install.yml")}"
  private_security_group_ids = ["${var.sg1}","${var.sg2}"]
  public_security_group_ids  = ["${var.sg1}","${var.sg2}"]
}

resource "ibm_compute_vm_instance" "node" {
  count                    = "${var.worker_node[node]}"
  hostname                 = "${var.worker_node[name]}-${count.index}"
  os_reference_code        = "${var.os_code}"
  domain                   = "${var.domain}"
  datacenter               = "${var.datacenter}"
  network_speed            = "${var.worker_node[nic]}"
  hourly_billing           = true
  private_network_only     = "${var.private_only}"
  cores                    = "${var.worker_node[vcpu]}"
  memory                   = "${var.worker_node[ram]}"
  disks                    = ["${var.worker_node[disk]}"]
  dedicated_acct_host_only = false
  local_disk               = false
  ssh_key_ids              = ["${ibm_compute_ssh_key.ssh_key.id}"]
  tags                     = ["${var.worker_node[tags]}"]
  user_metadata            = "${file("install.yml")}"
  private_security_group_ids = ["${var.sg1}","${var.sg2}"]
  public_security_group_ids  = ["${var.sg1}","${var.sg2}"]
}



output "public_ip_master" {
  value = "${ibm_compute_vm_instance.master.*.ipv4_address}"
}

output "public_ip_nodes" {
  value = "${ibm_compute_vm_instance.node.*.ipv4_address}"
}


output "hostname_master" {
  value = "${ibm_compute_vm_instance.master.*.hostname}"
}

output "hostname_nodes" {
  value = "${ibm_compute_vm_instance.node.*.hostname}"
}

output "base_name" {
  value = "${var.hostname}"
}



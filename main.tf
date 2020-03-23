##
## https://ibm-cloud.github.io/tf-ibm-docs/v0.14.1/
##
variable "sl_username" {}
variable "sl_api_key" {}
variable "ic_api_key" {}

### クラスタレベルの環境設定変数
### OpenShift cluster env

variable "domain" {}
variable "datacenter" {}
variable "sg1" {}
variable "sg2" {}

### SSH鍵
variable "ssh_user" {}
variable "ssh_label" {}
variable "ssh_notes" {}
variable "ssh_key" {}

### OSなど共通事項
variable "os_code" {}
variable "private_only" {}


### Mater node
#variable "master" {
#    num_of_node = "1"
#    hostname = "master"
#    vcpu = "2"
#    ram  = "4"
#    vol  = "25"
#    nic  = "100"
#    tag  = ""
#}	 

variable "master_node_num" {
  type = list
}

variable "master_hostname" {}
variable "master_vcpu" {}
variable "master_ram" {}
variable "master_disk_size" {}
variable "master_nic_speed" {}
variable "master_tags" {}

### Worker node
variable "node_num" {}
variable "node_hostname" {}
variable "node_vcpu" {}
variable "node_ram" {}
variable "node_disk_size" {}
variable "node_nic_speed" {}
variable "node_tags" {}

#
# IBM Cloud のAPIキーを変数ファイルから取得する
#
# https://ibm-cloud.github.io/tf-ibm-docs/index.html
#
provider "ibm" {
  softlayer_username = "${var.sl_username}"
  softlayer_api_key  = "${var.sl_api_key}"
  bluemix_api_key    = "${var.ic_api_key}"
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
  count                    = "${var.num_of_master}"
  hostname                 = "${var.hostname}-${count.index}"
  os_reference_code        = "${var.os_code}"
  domain                   = "${var.domain}"
  datacenter               = "${var.datacenter}"
  network_speed            = "${var.nic_speed}"
  hourly_billing           = true
  private_network_only     = "${var.private_only}"
  cores                    = "${var.vcpu}"
  memory                   = "${var.ram}"
  disks                    = ["${var.disk_size}"]
  dedicated_acct_host_only = false
  local_disk               = false
  ssh_key_ids              = ["${ibm_compute_ssh_key.ssh_key.id}"]
  tags                     = ["${var.tags}"]
  user_metadata            = "${file("install.yml")}"
  private_security_group_ids = ["${var.sg1}","${var.sg2}"]
  public_security_group_ids  = ["${var.sg1}","${var.sg2}"]
}

resource "ibm_compute_vm_instance" "node" {
  count                    = "${var.num_of_node}"
  hostname                 = "${var.hostname}-${count.index}"
  os_reference_code        = "${var.os_code}"
  domain                   = "${var.domain}"
  datacenter               = "${var.datacenter}"
  network_speed            = "${var.nic_speed}"
  hourly_billing           = true
  private_network_only     = "${var.private_only}"
  cores                    = "${var.vcpu}"
  memory                   = "${var.ram}"
  disks                    = ["${var.disk_size}"]
  dedicated_acct_host_only = false
  local_disk               = false
  ssh_key_ids              = ["${ibm_compute_ssh_key.ssh_key.id}"]
  tags                     = ["${var.tags}"]
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



##
## https://ibm-cloud.github.io/tf-ibm-docs/v0.14.1/
##
variable "sl_username" {}
variable "sl_api_key" {}
variable "ic_api_key" {}
variable "ibmcloud_api_key" {}

###
variable "hostname" {}
variable "domain" {}
variable "datacenter" {}
variable "os_code" {}
variable "vcpu" {}
variable "ram" {}
variable "disk_size" {}
variable "private_only" {}
variable "nic_speed" {}
variable "tags" {}
###
variable "ssh_user" {}
variable "ssh_label" {}
variable "ssh_notes" {}
variable "ssh_key" {}

##
variable "sg1" {}
variable "sg2" {}

##
variable "num_of_vsi" {
  type    = number
  default = 1
}


# https://ibm-cloud.github.io/tf-ibm-docs/index.html
#
provider "ibm" {
  iaas_classic_username = var.sl_username
  iaas_classic_api_key  = var.sl_api_key
  ibmcloud_api_key    =   var.ic_api_key
}

# https://ibm-cloud.github.io/tf-ibm-docs/v0.14.1/d/compute_ssh_key.html
#
resource "ibm_compute_ssh_key" "ssh_key" {
  label      = "$var.ssh_label"
  notes      = "$var.ssh_notes"
  #public_key = "${file("/vagrant/keys/key.pub")}"
  public_key = file("/vagrant/keys/key.pub")
}

# https://ibm-cloud.github.io/tf-ibm-docs/v0.14.1/r/compute_vm_instance.html
#
resource "ibm_compute_vm_instance" "vsi" {
  count                    = var.num_of_vsi
  hostname                 = "${var.hostname}-${count.index}"
  os_reference_code        = var.os_code
  domain                   = var.domain
  datacenter               = var.datacenter
  network_speed            = var.nic_speed
  hourly_billing           = true
  private_network_only     = var.private_only
  cores                    = var.vcpu
  memory                   = var.ram
  disks                    = ["${var.disk_size}"]
  dedicated_acct_host_only = false
  local_disk               = false
  ssh_key_ids              = ["${ibm_compute_ssh_key.ssh_key.id}"]
  tags                     = ["${var.tags}"]
  user_metadata            = file("install.yml")
  private_security_group_ids = ["${var.sg1}","${var.sg2}"]
  public_security_group_ids  = ["${var.sg1}","${var.sg2}"]
}


output "public_ip" {
  value = "${ibm_compute_vm_instance.vsi.*.ipv4_address}"
}

output "hostname" {
  value = "${ibm_compute_vm_instance.vsi.*.hostname}"
}

output "base_name" {
  value = "${var.hostname}"
}



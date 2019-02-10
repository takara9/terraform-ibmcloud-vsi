#sl_username = ""
#sl_api_key  = ""
#ic_api_key  = ""
#org_name    = ""
#space_name  = ""

##
hostname   = "worker"
domain     = "takara.org"

## bx sl vs options
datacenter = "tok05"
os_code    = "UBUNTU_16_64"
vcpu       = "1"
ram        = "1024"
disk_size  = "25"
private_only = "false"
nic_speed  = "100"
tags       = "TF"

##
ssh_user   = "root"
ssh_label  = "takara3"
ssh_notes  = "SSH note"
#ssh_key    = ""

## セキュリティ・グループのID
# bx sl securitygroup list
sg1 = "130379" # allow_all
sg2 = "130381" # allow_outbound

## ノード数
num_of_vsi = "3"

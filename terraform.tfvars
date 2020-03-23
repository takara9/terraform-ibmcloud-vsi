## secret.tfvars の置き換え対象
#sl_username = ""
#sl_api_key  = ""
#ic_api_key  = ""
#org_name    = ""
#space_name  = ""

## ホストとドメイン名
hostname   = "node"
domain     = "sample.org"

## ノード数
num_of_master = "1"
num_of_node   = "2"

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
ssh_label  = "key-for-tf"
ssh_notes  = "Terraform ssh-key"
#ssh_key    = "" # サーバーに公開鍵を設定する

## セキュリティ・グループのIDで Public VLAN とPrivate VLAN のアクセス制御を設定
# bx sl securitygroup list
sg1 = "130379" # allow_all
sg2 = "130381" # allow_outbound





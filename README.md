# terraform-ibmcloud-vsi

このコードは、Terraform と Terraform-Provider for IBM Cloud を使って、仮想サーバーのプロビジョニングを自動化するツールです。　概要などの説明は、[Terraform + Cloud-init + Ansible で IBM Cloud VSIプロビジョニング自動化](https://qiita.com/MahoTakara/items/0b23d9bca3edcfe0081c)に書きました。

このコードの実行は、GitHub [takara9/vagrant-terraform](https://github.com/takara9/vagrant-terraform)で起動する仮想サーバーを前提としています。



## 初期化

~~~
$ cd terraform-ibmcloud-vsi
$ terraform init -plugin-dir="/usr/local/bin" 
~~~


## ドライラン

~~~
$ terraform plan -var-file=.secret.tfvars
~~~


## プロビジョニング

~~~
$ terraform apply -var-file=.secret.tfvars
~~~


## クリーンナップ

~~~
$ terraform destroy -var-file=.secret.tfvars
~~~


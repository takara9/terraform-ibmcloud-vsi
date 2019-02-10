#!/usr/bin/env python                                                           
# -*- coding:utf-8 -*-                                                          
#                                                                               
import json
import shutil

## teraform.tfstate の output を読んで、Ansible の Inventoryファイルを作る
buf = open('terraform.tfstate').read()
dic = json.loads(buf)
m = dic['modules'][0]

hostname = []
public_ip = []
lines = []

for x in m['outputs']['hostname']['value']:
    hostname.append(x)

for x in m['outputs']['public_ip']['value']:    
    public_ip.append(x)

    
priv_key = 'keys/key'
form = '{0} ansible_ssh_host={1} ansible_ssh_private_key_file={2} ansible_ssh_user="root"\n'    
n_of_host = len(hostname)
bass_name = 'tkr01tf-'

## ノードデータ作成
for i in range(0,n_of_host):
    line = form.format(hostname[i], public_ip[i], priv_key)
    lines.append(line)


## インベントリファイルのバックアップ    
src = './playbooks/hosts'
dst = './playbooks/hosts.backup'
shutil.copyfile(src,dst)


## Terraformから起動したノードのエントリを追加
with open(src, mode='a') as f:
    for l in lines:
        f.write(l)
    f.write('[nodes]\n')
    f.write('{0}[0:{1}]'.format(base_name,n_of_host))



#!/usr/bin/env python                                                           
# -*- coding:utf-8 -*-                                                          
#                                                                               
import json
import shutil

## teraform.tfstate の output を読んで、Ansible の Inventoryファイルを作る
buf = open('terraform.tfstate').read()
dic = json.loads(buf)
m = dic['outputs']

hostname = []
public_ip = []
lines = []

for x in m['hostname_master']['value']:
    hostname.append(x)

for x in m['public_ip_master']['value']:    
    public_ip.append(x)

for x in m['hostname_nodes']['value']:
    hostname.append(x)

for x in m['public_ip_nodes']['value']:    
    public_ip.append(x)
    

    
## 全インベントリのリスト作成
priv_key = '~/keys/key'
form = '{0} ansible_ssh_host={1} ansible_ssh_private_key_file={2} ansible_ssh_user="root"\n'    
for i in range(0,len(hostname)):
    line = form.format(hostname[i], public_ip[i], priv_key)
    lines.append(line)

    
## インベントリファイルのバックアップ    
src = './playbooks/hosts'
dst = './playbooks/hosts.backup'
shutil.copyfile(src,dst)

## Terraformから起動したノードのエントリを追加
with open(src, mode='w') as f:
    for l in lines:
        f.write(l)
    f.write('[masters]\n')
    f.write('{0}[0:{1}]'.format("master",len(m['hostname_master']['value'])-1))
    f.write('\n')    
    f.write('[nodes]\n')
    f.write('{0}[0:{1}]'.format("node",len(m['hostname_nodes']['value'])-1))
    f.write('\n')    


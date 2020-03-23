#!/usr/bin/env python                                                           
# -*- coding:utf-8 -*-                                                          
#                                                                               
import json
import shutil
import os

## teraform.tfstate の output を読んで、Ansible の Inventoryファイルを作る
buf = open('terraform.tfstate').read()
dic = json.loads(buf)
m = dic['outputs']

hostname = []
public_ip = []
private_ip = []
lines = []


for x in m['hostname_master']['value']:
    hostname.append(x)

for x in m['public_ip_master']['value']:    
    public_ip.append(x)

for x in m['private_ip_master']['value']:    
    private_ip.append(x)
    
for x in m['hostname_nodes']['value']:
    hostname.append(x)

for x in m['public_ip_nodes']['value']:    
    public_ip.append(x)

for x in m['private_ip_nodes']['value']:    
    private_ip.append(x)
    

#
# terraformに続くansibleについてのインベントリファイル作成
#
    
## 全インベントリのリスト作成
priv_key = '~/keys/key'
form = '{0} ansible_ssh_host={1} ansible_ssh_private_key_file={2} ansible_ssh_user="root"\n'    
for i in range(0,len(hostname)):
    line = form.format(hostname[i], public_ip[i], priv_key)
    lines.append(line)

    
## インベントリファイルのバックアップ
src = './playbooks/hosts'
dst = './playbooks/hosts.backup'
if os.path.exists(src):
    shutil.copyfile(src,dst)

    
## Terraformから起動したノードのエントリを追加
with open(src, mode='w') as f:
    for l in lines:
        f.write(l)
    f.write('\n\n')
    f.write('[masters]\n')
    f.write('{0}[0:{1}]'.format("master",len(m['hostname_master']['value'])-1))
    f.write('\n\n')
    f.write('[nodes]\n')
    f.write('{0}[0:{1}]'.format("node",len(m['hostname_nodes']['value'])-1))
    f.write('\n\n')

#
# playbook テンプレートのhosts作成
#   playbooks/okd/templates/hosts.j2
#
lines_template = []
temp_hosts = 'playbooks/okd/templates/hosts.j2'
domain = 'example.com'
form = '{0}    {1}    {1}.{2}\n'    

lines_template.append('127.0.0.1   localhost localhost.localdomain\n\n')
for i in range(0,len(hostname)):
    line = form.format(private_ip[i], hostname[i], domain)
    lines_template.append(line)
with open(temp_hosts, mode='w') as f:
    for l in lines_template:
        f.write(l)

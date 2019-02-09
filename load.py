#!/usr/bin/env python                                                           
# -*- coding:utf-8 -*-                                                          
#                                                                               
import json

buf = open('terraform.tfstate.test').read()
dic = json.loads(buf)
m = dic['modules'][0]

hostname = []
public_ip = []
lines = []

for x in m['outputs']['hostname']['value']:
    hostname.append(x)

for x in m['outputs']['public_ip']['value']:    
    public_ip.append(x)

    
priv_key = '/vagrant/.vagrant/machines/node2/virtualbox/private_key'
form = '{0} ansible_ssh_host={1} ansible_ssh_private_key_file={2}\n'    

for i in range(0,len(hostname)):
    #line = '{0} {1}'.format(public_ip[i],hostname[i])
    line = form.format(hostname[i], public_ip[i], priv_key)
    lines.append(line)


    
with open('hosts.test', mode='w') as f:
    for l in lines:
        f.write(l)



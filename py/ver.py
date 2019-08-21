#!/usr/bin/python3

import requests
import platform

f = open('pos_update.log', 'r')
l = f.read().splitlines()
l = [x for x in l if x != '']
posver = l[-1]

winver = platform.release() + '_' + platform.machine()

pyver = platform.python_version() 

url = 'http://192.168.10.55/api/ver'
payload = {
    'posver': posver,
    'winver': winver,
    'pyver': pyver
    }

r = requests.post(url, timeout = 2, data = payload)

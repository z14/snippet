#!/usr/bin/python 
import platform
import requests
# import time

v = platform.python_version() 
url = 'http://192.168.10.55/api/pyver'

r = requests.post(url, timeout = 1, data = {'pyver' : v})

# print(r.text)
# time.sleep(2)

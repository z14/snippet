#!/usr/bin/python 
import requests
import sys
# import time

f = open('pos_update.log', 'r')
l = f.read().splitlines()
l = [x for x in l if x != '']

v = l[-1]
url = 'http://192.168.10.55/api/posver'

r = requests.post(url, timeout = 1, data = {'posver' : v})

# print(r.text)
# time.sleep(2)

#!/usr/bin/python3

import os
import sys
import requests
from bs4 import BeautifulSoup
 
def getSoup(url):
    headers = {'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36'}
    html = requests.get(url, headers=headers).text
    return BeautifulSoup(html, 'html.parser')

if len(sys.argv) > 1:
    print("url:", sys.argv[1])
    url = sys.argv[1]
    print(url)

    soup = getSoup(url)
    imgs = soup.select('.wp-block-gallery figure img')
    # print(imgs)
    
    dir = 'pics/'
    os.makedirs(dir, 0o755, True)

    for i in imgs:
        url = i['src']
        file = requests.get(url)
        filename = url.split('/')[-1]
        open(dir + filename, 'wb').write(file.content)
        print(url)
        print(filename)
else:
    print('pls enter url')

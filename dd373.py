#!/usr/bin/python3

from bs4 import BeautifulSoup
import requests

MIN_PRICE = 600

url = 'https://dl.dd373.com/need/eja7u2-0-0-0-0-0-0-0-0-0-0.html'
headers = {'user-agent': 'fuck/0.0.1'}
html = requests.get(url, headers = headers).text
soup = BeautifulSoup(html, 'html.parser')
# print(soup)

glist = soup.select('.gl_content')

for i in glist:
    price = i.select_one('.goods_os').text.strip().lstrip('￥')
    if float(price) < MIN_PRICE:
        continue
    deposit1 = i.select_one('.goods_xqensurem').text.strip().lstrip('￥')
    deposit2 = i.select_one('.goods_xlm').text.strip().lstrip('￥')
    deposit = float(deposit1) + float(deposit2)
    days = i.select_one('.goods_time').text.strip()

    title = i.select_one('.goods_t .title a').text.strip()
    realmSum = i.select_one('.goods_t .mrgl7').find('div', attrs={'class': None}).select('a')
    realm = realmSum[1].text +  ' ' + realmSum[2].text + ' ' + realmSum[3].text

    print(title, price, deposit, days, realm)

#!/usr/bin/python3

from bs4 import BeautifulSoup
import requests
import pymysql.cursors

MIN_PRICE = 600

source = 'dd373'
url = 'https://dl.dd373.com/need/eja7u2-0-0-0-0-0-0-0-0-0-0.html'
headers = {'user-agent': 'fuck/0.0.1'}
html = requests.get(url, headers = headers).text
soup = BeautifulSoup(html, 'html.parser')

conn = pymysql.connect(
        host='localhost',
        user='wowjob',
        password='wowjob',
        db='wowjob',
        cursorclass=pymysql.cursors.DictCursor
        )
cursor = conn.cursor()

sql = f"select * from job where source = '{source}' order by id desc limit 1"
cursor.execute(sql)
res = cursor.fetchone()
if res:
    last = res['gid']
else:
    last = 0

glist = soup.select('.gl_content')

for i in glist:
    gid =  i.select_one('.goods_t .title a')['href'].lstrip('/NeedDetail-').rstrip('.html')
    if gid == last:
        break
    price = i.select_one('.goods_os').text.strip().lstrip('￥')
    if float(price) < MIN_PRICE:
        continue
    deposit1 = i.select_one('.goods_xqensurem').text.strip().lstrip('￥')
    deposit2 = i.select_one('.goods_xlm').text.strip().lstrip('￥')
    deposit = float(deposit1) + float(deposit2)
    days = i.select_one('.goods_time').text.strip()

    title = i.select_one('.goods_t .title a').text.strip()
    realmSum = i.select_one('.goods_t .mrgl7').find('div', attrs={'class': None}).select('a')
    zone = realmSum[1].text
    realm = realmSum[2].text
    faction = realmSum[3].text

    # database;
    sql = f"insert into job (gid, price, deposit, days, title, zone, realm, faction, source) values ('{gid}', '{price}', '{deposit}', '{days}', '{title}', '{zone}', '{realm}','{faction}', '{source}')"
    cursor.execute(sql)
    conn.commit()

    # msg = int(float(price)),'\t', int(deposit), '\t', days, '\t', zone, '\t', realm, '\t', faction, '\t', title
    
    # some api

    print(int(float(price)),'\t', int(deposit), '\t', days, '\t', zone, '\t', realm, '\t', faction, '\t', title)

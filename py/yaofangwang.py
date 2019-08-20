#!/usr/bin/python3

import requests
from bs4 import BeautifulSoup
import pymysql.cursors

conn = pymysql.connect(
        host='localhost',
        user='yfw',
        password='yfw',
        db='yfw',
        cursorclass=pymysql.cursors.DictCursor
        )

def main():
    global ourPrice
    url = 'https://www.yaofangwang.com/yaodian/379739/medicines.html'
    soup = getSoup(url)
    pageCount = soup.select_one('span.num').text.strip().lstrip('1 ').lstrip('/ ')
    for i in range(1, int(pageCount) + 1):
        url = f'https://www.yaofangwang.com/yaodian/379739/medicines.html?page={i}'
        soup = getSoup(url)
        li = soup.select('ul.goods3 li')
        for i in li:
            url = 'https:' + i.a['href']
            print(url)
            seen = []
            soup = getSoup(url)
            drugId = soup.select_one('#aFavorite')['data-mid']
            ourPrice = soup.select_one('#pricedl span').string.strip()
            if int(drugId) in seen:
                print(drugId, 'already done, skipping it')
                continue
            getPrice(drugId)

def getSoup(url):
    headers = {'user-agent': 'fucku/0.0.1'}
    html = requests.get(url, headers=headers).text
    return BeautifulSoup(html, 'html.parser')

def getInfo(drugId):
    url = 'https://www.yaofangwang.com/medicine-' + str(drugId) + '.html'
    print(url)
    soup = getSoup(url)
    
    retailerCount = soup.select_one('#priceABtn b').string
    
    if int(retailerCount) == 0:
        exit()
    
    info = soup.select('div.maininfo div.info dd')
    
    name = info[0].string
    if info[2].div == None:
        spec = info[2].text.strip()
    else:
        spec = info[2].div.div.text.strip()
    form = info[3].string
    facto = info[4].string
    # pagenum = soup.select_one('#slist span.num').text.lstrip('1 / ')
    pagenum = soup.select_one('#slist span.num').text.strip().lstrip('1 ').lstrip('/ ')
    pagenum = int(pagenum)
    # print(name, spec, form, facto, pagenum)
    with conn.cursor() as cursor:
        sql = f"insert into drug (drugId, name, spec, form, facto, ourPrice) values ('{drugId}', '{name}', '{spec}', '{form}', '{facto}', '{ourPrice}')"
        try:
            cursor.execute(sql)
            # print(cursor.fetchall())
        except:
            print('We already have', drugId)
    conn.commit()
    return pagenum


def getPrice(drugId):
    pagenum = getInfo(drugId)
    # if pagenum > 1:
    for i in range(1, pagenum + 1):
        url = 'https://www.yaofangwang.com/medicine-' + str(drugId) + '-p' + str(i) + '.html'
        soup = getSoup(url)
        li = soup.select('#slist .slist li')
        for i in li:
            price = i.select_one('p.money').string.strip().lstrip('¥')
            retailer = i.select_one('a.stitle').string
            # print(price, retailer)
            with conn.cursor() as cursor:
                sql = f"insert into price (drugId, price, retailer) values ('{drugId}', '{price}', '{retailer}')"
                cursor.execute(sql)
                # print(cursor.fetchall())
            conn.commit()

main()

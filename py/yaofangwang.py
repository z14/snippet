#!/usr/bin/python3
# 抓取 https://www.yaofangwang.com/yaodian/379739/medicines.html 页面所有

# 导入模块
import requests
from bs4 import BeautifulSoup
import pymysql.cursors

# 创建 mysql 对象
conn = pymysql.connect(
        host='localhost',
        user='yfw',
        password='yfw',
        db='yfw',
        cursorclass=pymysql.cursors.DictCursor
        )
cursor = conn.cursor()
ourPrice = ''

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
            getInfo(drugId)
            # getPrice(drugId)

def getSoup(url):
    """ 返回 BeautifulSoup 对象 """
    headers = {'user-agent': 'fucku/0.0.1'}
    html = requests.get(url, headers=headers).text
    return BeautifulSoup(html, 'html.parser')

def getInfo(drugId):
    url = 'https://www.yaofangwang.com/medicine-' + str(drugId) + '.html?sort=sprice&sorttype=desc'
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
    imgURL = 'https:' + soup.select_one('div.maininfo div.info dd img')['src']
    priceMin = soup.select_one('.maininfo div.info label.num').text.rstrip(' 起')

    priceMaxTag = soup.select_one('#slist .slist li p.money')
    if priceMaxTag == None:
        priceMax = ''
    else:
        priceMax = priceMaxTag.string.strip().lstrip('¥')

    # print(name, spec, form, facto)
    sql = f"insert into drug (drugId, name, spec, form, facto, ourPrice, priceMax, priceMin, imgURL) values ('{drugId}', '{name}', '{spec}', '{form}', '{facto}', '{ourPrice}', '{priceMax}', '{priceMin}', '{imgURL}')"
    try:
        cursor.execute(sql)
        # print(cursor.fetchall())
    except:
        print('We already have', drugId)
    conn.commit()


def getPrice(drugId):
    url = 'https://www.yaofangwang.com/medicine-' + str(drugId) + '.html'
    soup = getSoup(url)
    pagenum = soup.select_one('#slist span.num').text.strip().lstrip('1 ').lstrip('/ ')
    for i in range(2, int(pagenum) + 1):
        url = 'https://www.yaofangwang.com/medicine-' + str(drugId) + '-p' + str(i) + '.html'
        soup = getSoup(url)
        li = soup.select('#slist .slist li')
        for i in li:
            price = i.select_one('p.money').string.strip().lstrip('¥')
            retailer = i.select_one('a.stitle').string
            # print(price, retailer)
            sql = f"insert into price (drugId, price, retailer) values ('{drugId}', '{price}', '{retailer}')"
            cursor.execute(sql)
            # print(cursor.fetchall())
            conn.commit()


main()

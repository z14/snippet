#!/usr/bin/python3

import pymysql.cursors

conn = pymysql.connect(
        host='localhost',
        user='yfw',
        password='yfw',
        db='yfw',
        cursorclass=pymysql.cursors.DictCursor
        )

sql = 'select drugid from drug'
c = conn.cursor()
c.execute(sql)
r = c.fetchall()

# print(r[0]['drugid'])

for i in r:
    drugid = i['drugid']
    sql = f'select max(price) max, min(price) min from price where drugid = {drugid}'
    # print(sql)
    c.execute(sql)
    r = c.fetchone()
    max = r['max']
    min = r['min']

    sql = f'update drug set priceMax = {max}, priceMin = {min} where drugid = {drugid}'
    c.execute(sql)
    conn.commit()
    # print(sql)


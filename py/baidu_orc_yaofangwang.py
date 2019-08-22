#!/usr/bin/python3

import os
import pymysql
import urllib.request
from aip import AipOcr
from time import localtime, strftime
import time

APP_ID = '17060347'
API_KEY = 'b9KtvxMyzULDmMp6ezBTdNIl'
SECRET_KEY = '4KwRbDz0kjHVmMMMrKbjtu9TyehEIQGq'

client = AipOcr(APP_ID, API_KEY, SECRET_KEY)

conn = pymysql.connect(
        host='localhost',
        user='yfw',
        password='yfw',
        db='yfw',
        cursorclass=pymysql.cursors.DictCursor
        )
cursor = conn.cursor()
sql = 'select drugId, imgURL from drug'
cursor.execute(sql)
r = cursor.fetchall()

def get_file_content(filePath):
    with open(filePath, 'rb') as fp:
        return fp.read()

imgdir = 'img_' + strftime('%Y%m%d%H%M%S', localtime())
os.mkdir(imgdir)

for i in r:
    drugId = str(i['drugId'])
    filename = imgdir + '/' + drugId + '.jpg'
    url = i['imgURL'].replace('https', 'http')
    # download images
    urllib.request.urlretrieve(url, filename)
    # scale images
    os.system(f'convert {filename} -resize x16 {filename}')
    # ocr
    image = get_file_content(filename)
    r = client.basicAccurate(image);
    print(r)
    approvalNum = r['words_result'][0]['words']
    print(drugId, approvalNum)

    sql = f"update drug set approvalNum = '{approvalNum}' where drugId = {drugId}"
    cursor.execute(sql)
    conn.commit()
    time.sleep(0.5)

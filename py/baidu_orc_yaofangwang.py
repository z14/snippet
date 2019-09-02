#!/usr/bin/python3
# 从数据库中获取批准文号的图片链接，调用百度云 API 从图片中识别文字，写入数据库
# 百度云通用文字识别高精度版，每日免费调用 500 次，超过后即调用失败

# 导入模块
import os
import pymysql
import redis
import urllib.request
from aip import AipOcr
from time import localtime, strftime
import time

# 全局变量
# 百度云授权信息
APP_ID = '17060347'
API_KEY = 'b9KtvxMyzULDmMp6ezBTdNIl'
SECRET_KEY = '4KwRbDz0kjHVmMMMrKbjtu9TyehEIQGq'

# 创建百度 OCR 对象
client = AipOcr(APP_ID, API_KEY, SECRET_KEY)

# 创建 redis 对象
r = redis.Redis(host='localhost', decode_responses=True)
# 程序将在 redis 中记录变量 offset ，以便程序异常中断后，重新打开可以继续之前的进度
offset = r.get('offset')
if offset == None:
    offset = 0
else:
    offset = int(offset)

# 创建 mysql 对象
conn = pymysql.connect(
        host='localhost',
        user='yfw',
        password='yfw',
        db='yfw',
        cursorclass=pymysql.cursors.DictCursor
        )
cursor = conn.cursor()
sql = f'select drugId, imgURL from drug limit {offset},2000'
cursor.execute(sql)
# 获取 sql 查询结果
result = cursor.fetchall()

def get_file_content(filePath):
    with open(filePath, 'rb') as fp:
        return fp.read()

# 图片下载保存路径
imgdir = 'img_' + strftime('%Y%m%d%H%M%S', localtime())
os.mkdir(imgdir)

for i in result:
    drugId = str(i['drugId'])
    filename = imgdir + '/' + drugId + '.jpg'
    url = i['imgURL'].replace('https', 'http')
    # 下载图片
    urllib.request.urlretrieve(url, filename)
    # 百度文字识别限制图片最小边长 > 15px ，药房网批准文号图片高 14px ，故调用 imagemagick 修改尺寸
    os.system(f'convert {filename} -resize x16 {filename}')
    # 获取百度文字识别 API 响应
    image = get_file_content(filename)
    resp = client.basicAccurate(image);
    approvalNum = resp['words_result'][0]['words']
    print(drugId, approvalNum)

    sql = f"update drug set approvalNum = '{approvalNum}' where drugId = {drugId}"
    cursor.execute(sql)
    conn.commit()
    time.sleep(0.5)
    # offset 加 1 并刷新 redis
    offset += 1
    r.set('offset', offset)

# 程序正常结束，删除 offset
r.delete('offset')

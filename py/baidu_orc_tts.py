#!/usr/bin/python3
# 从数据库中获取批准文号的图片链接，调用百度云 API 从图片中识别文字，写入数据库
# 百度云通用文字识别高精度版，每日免费调用 500 次，超过后即调用失败

# 导入模块
import os
import shutil
from aip import AipOcr
from aip import AipSpeech


APP_ID = '17060347'
API_KEY = 'b9KtvxMyzULDmMp6ezBTdNIl'
SECRET_KEY = '4KwRbDz0kjHVmMMMrKbjtu9TyehEIQGq'
client = AipOcr(APP_ID, API_KEY, SECRET_KEY)

filename = 'j.jpg';

def get_file_content(filePath):
    with open(filePath, 'rb') as fp:
        return fp.read()

image = get_file_content(filename)
resp = client.basicAccurate(image)

text = ''
# text = resp['words_result'][0]['words']
# text = text + resp['words_result'][1]['words']

for i in resp['words_result']:
    text = text + i['words']
    print(i)
    
print(text)

APP_ID = '21459608'
API_KEY = '16ZHe0xOcs9iG1QGaPt44xU9'
SECRET_KEY = 'dSDoUAvulKxgoYt8hVaUIyU9jggXgpNb'
client = AipSpeech(APP_ID, API_KEY, SECRET_KEY)

# text = '合成文本长度必须小于1024字节，如果本文长度较长，可以采用多次请求的方式。文本长度不可超过限制'
res = client.synthesis(text, 'zh', 1, {
    'vol': 5,
    'spd': 4,
    'per': 3,
    })


if not isinstance(res, dict):
    with open('auido.mp3', 'wb') as f:
        f.write(res)

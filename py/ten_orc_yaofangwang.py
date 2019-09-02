#!/usr/bin/python3
# 从数据库中获取批准文号的图片链接，调用腾讯云 API 从图片中识别文字，写入数据库
# 腾讯云通用文字识别高精度版，每月免费调用 1000 次，超过即开始计费，慎用！

# 导入模块
import os
import time
import pymysql
import redis

from tencentcloud.common import credential
from tencentcloud.common.profile.client_profile import ClientProfile
from tencentcloud.common.profile.http_profile import HttpProfile
from tencentcloud.common.exception.tencent_cloud_sdk_exception import TencentCloudSDKException
from tencentcloud.ocr.v20181119 import ocr_client, models

# 全局变量
# 腾讯云授权信息
secret_id = 'AKIDGxp9GNXyRfsJU0p1HLJ6nIXZOOC4e7HC'
secret_key = '5wZ0B2h6HCxVs0lJeicw3dyykGZt56TZ'

r = redis.Redis(host='localhost', decode_responses=True)
offset = r.get('offset')
if offset == None:
    offset = 0
else:
    offset = int(offset)

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
result = cursor.fetchall()




try:
    cred = credential.Credential(secret_id, secret_key)
    httpProfile = HttpProfile()
    httpProfile.endpoint = "ocr.tencentcloudapi.com"

    clientProfile = ClientProfile()
    clientProfile.httpProfile = httpProfile
    client = ocr_client.OcrClient(cred, "ap-guangzhou", clientProfile)

    req = models.GeneralAccurateOCRRequest()

    for i in result:
        drugId = str(i['drugId'])
        req.ImageUrl = i['imgURL']
        resp = client.GeneralAccurateOCR(req)
        # print(resp.to_json_string())
        approvalNum = resp.TextDetections[0].DetectedText
        print(drugId, approvalNum)

        sql = f"update drug set approvalNum = '{approvalNum}' where drugId = {drugId}"
        #cursor.execute(sql)
        #conn.commit()
        time.sleep(0.5)
        offset += 1
        r.set('offset', offset)

    r.delete('offset')

except TencentCloudSDKException as err:
    print(err)


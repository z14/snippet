#!/usr/bin/python3

import boto3
import base64

c = boto3.client('textract')

f = open('hi.jpg', 'rb')

encoded = bytearray(f.read())

r = c.detect_document_text(Document={'Bytes': encoded})

print(r)

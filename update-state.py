#!/usr/bin/python
import json
import boto3

dynamodb = boto3.client('dynamodb', region_name='us-east-1')

with open('/home/tap-kustomer/kustomer-state.json') as f:
    state_file = json.load(f)

bookmarks = ['conversations','customers','kobjects','messages','shortcuts','tags','users','notes','teams']

for i in bookmarks:
    state = state_file['bookmarks'][i]
    item = '{"bookmark": {"S":"' + i + '"},"lastExec":{"S":"' + state + '"}}'
    print(item)
    item = json.loads(item)
    dynamodb.put_item(TableName='kustomer_state_prod', Item=item)


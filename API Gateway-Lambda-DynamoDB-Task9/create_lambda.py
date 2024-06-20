import boto3
import os
import json
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    item = json.loads(event['body'])
    item['id'] = str(uuid.uuid4())
    table.put_item(Item=item)
    
    return {
        'statusCode': 200,
        'body': json.dumps(item)
    }

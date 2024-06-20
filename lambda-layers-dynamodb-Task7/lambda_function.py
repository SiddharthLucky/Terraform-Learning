import boto3
import csv
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])


def lambda_handler(event, context):
    with open('/opt/data.csv', 'r') as csvfile:
        csvreader = csv.DictReader(csvfile)
        for row in csvreader:
            table.put_item(
                Item={
                    "Name": row['\ufeffName'],
                    "HEX": row['HEX'],
                    "RGB": row['RGB']
                })
    return {
        'statusCode': 200,
        'body': 'Data inserted successfully'
    }

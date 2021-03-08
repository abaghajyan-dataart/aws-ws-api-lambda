import boto3
import random

def lambda_handler(event, context):
    client = boto3.resource("dynamodb")
    table = client.Table("Words")
    words = table.scan()['Items']
    word = random.choice(words)
    return {
        'statusCode': 200,
        'body': word["Word"]
    }
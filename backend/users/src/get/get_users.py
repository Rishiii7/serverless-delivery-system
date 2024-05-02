import boto3
import os

def lambda_handler(events, context):
    """
    Lambda Function to get the data from the DynamoDB Table
    """

    # Fetching the appropriate table 
    table_name = os.environ['DYNAMODB_TABLE_NAME']
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)

    data = table.scan()

    return data['Items']


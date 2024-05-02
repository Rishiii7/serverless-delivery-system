import boto3
import uuid
import os

import boto3.resources

def lambda_handler(event, context):
    """
    Lambda Function to push the data into the DynamoDB Table
    """

    # Fetching the appropriate table 
    table_name = os.environ['DYNAMODB_TABLE_NAME']
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)

    result = None
    people = [
        { 'userid' : 'marivera', 'name' : 'Martha Rivera'},
        { 'userid' : 'nikkwolf', 'name' : 'Nikki Wolf'},
        { 'userid' : 'pasantos', 'name' : 'Paulo Santos'},
    ]

    with table.batch_writer() as batch:
        for person in people:

            item = {
                '_id' : uuid.uuid4().hex,   # Ramdom ID
                'UserId' : person['userid'],
                'Name' : person['name']
            }
            print(f"> batch writing : {person['userid']}")
            batch.put_item(Item=item)

        result = f"Successfully Added {len(people)} into {table_name}"


    return {
        "statusCode": 200,
        "message" : result
    }
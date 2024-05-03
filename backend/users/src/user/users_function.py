import boto3
import uuid
import os
import boto3.resources
import json
from datetime import datetime

USERS_TABLE = os.environ['USERS_TABLE']
dynamodb = boto3.resource('dynamodb')
dbtable = dynamodb.Table(USERS_TABLE)

def lambda_handler(event, context):
    """
    Lambda Function to push the data into the DynamoDB Table
    """

    route_key = f"{event['httpMethod']} {event['resource']}"

    #set default response
    status_code = 400
    response_body = {'Message' : 'Unsupported route'}
    headers = {
        'Content-Type' : 'application/json',
        'Access-Control-Allow-Origin': '*',
    }

    try:
        # Get a list of all User
        if route_key == "GET /users":
            ddb_response = dbtable.scan(Select='ALL_ATTRIBUTES')
            response_body = ddb_response['Items']
            status_code = 200
        
        # Read a user by ID
        if route_key == "GET /users/{userid}":
            ddb_response = dbtable.get_item(Key={'userid': event["pathParameters"]["userid"]})

            # return single item instead of full DynamoDB response
            if 'Item' in ddb_response:
                response_body = ddb_response['Item']
            else:
                response_body = {}
            
            status_code = 200

        # Delete User by ID
        if  route_key == "DELETE /users/{userid}":
            result = dbtable.delete_item(
                       Key={'userid': event["pathParameters"]["userid"]},
                   )
            print(f"Delete Result: {result}")
            status_code = 200
            response_body = {}

        #create new user
        if  route_key == "POST /users":
            request_json = json.loads(event['body'])
            request_json['timestamp'] = datetime.now().isoformat()
            # generate unique id it it isn't present in the request
            if 'userid' not in request_json:
                request_json['userid'] = str(uuid.uuid1())
            # update the database
            result = dbtable.put_item(Item=request_json)
            print(f"Result after  put is {result}")
            status_code = 200
            response_body = request_json

        # update a specific user
        if  route_key == "PUT /users/{userid}":
            # update item in the databse
            request_json = json.loads(event['body'])
            request_json['timestamp'] = datetime.now().isoformat()
            request_json['userid'] = event['pathParameters']['userid']
            result = dbtable.put_item(
                Item=request_json,
            )
            print(f"Update Result is {result}")
            status_code = 200
            response_body = request_json


        
    except Exception as err:
        status_code = 400
        response_body = {'Error' : str(err)}
        print(str(err))


    return {
        "statusCode": status_code,
        "body" : json.dumps(response_body),
        "headers" : headers
    }
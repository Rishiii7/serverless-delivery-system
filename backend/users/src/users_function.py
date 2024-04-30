def lambda_handler(event, context):
    message = 'Hello from lambda'

    return {
        "statusCode": 200,
        "message" : message
    }
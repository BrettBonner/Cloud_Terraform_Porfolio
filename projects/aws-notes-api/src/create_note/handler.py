import boto3, os, json, uuid

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    body = json.loads(event["body"])
    note_id = str(uuid.uuid4())
    item = {"noteId": note_id, "content": body["content"]}
    table.put_item(Item=item)
    return {"statusCode": 201, "body": json.dumps(item)}

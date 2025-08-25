import boto3, os, json, uuid

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body") or "{}")
        content = body.get("content")
        if not content or not isinstance(content, str):
            return {"statusCode": 400, "body": json.dumps({"error": "content required"})}

        note_id = str(uuid.uuid4())
        item = {"noteId": note_id, "content": content}
        table.put_item(Item=item)

        return {
            "statusCode": 201,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(item),
        }
    except Exception as e:
        # minimal error reporting
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

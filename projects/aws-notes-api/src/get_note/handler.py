import boto3, os, json

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    note_id = (event.get("pathParameters") or {}).get("id")
    if not note_id:
        return {"statusCode": 400, "body": json.dumps({"error": "id required"})}

    resp = table.get_item(Key={"noteId": note_id})
    item = resp.get("Item")
    if not item:
        return {"statusCode": 404, "body": json.dumps({"error": "not found"})}

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(item),
    }

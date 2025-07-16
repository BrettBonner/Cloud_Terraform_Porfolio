const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME;

exports.handler = async (event) => {
  const shortCode = event.pathParameters.shortcode;

  const result = await ddb.get({
    TableName: TABLE_NAME,
    Key: { shortCode },
  }).promise();

  if (!result.Item) {
    return { statusCode: 404, body: "Not found" };
  }

  return {
    statusCode: 301,
    headers: { Location: result.Item.longUrl },
    body: null,
  };
};

const AWS = require("aws-sdk");
const crypto = require("crypto");
const ddb = new AWS.DynamoDB.DocumentClient();

const TABLE_NAME = process.env.TABLE_NAME;

exports.handler = async (event) => {
  const body = JSON.parse(event.body);
  const longUrl = body.url;

  if (!longUrl) {
    return { statusCode: 400, body: "Missing URL" };
  }

  const shortCode = crypto.randomBytes(3).toString("hex");

  await ddb.put({
    TableName: TABLE_NAME,
    Item: {
      shortCode,
      longUrl,
    },
  }).promise();

  return {
    statusCode: 200,
    body: JSON.stringify({ shortUrl: `${process.env.BASE_URL}/${shortCode}` }),
  };
};

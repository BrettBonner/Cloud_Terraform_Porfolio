# Packages the Lambda from the source directory
data "archive_file" "zip" {
  type        = "zip"
  source_dir  = var.source_path
  output_path = "${path.module}/.build/${var.fn_name}.zip"
}

# IAM role for Lambda
resource "aws_iam_role" "this" {
  name = "${var.fn_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# Inline policy passed from root (least-privilege to your DynamoDB table)
resource "aws_iam_role_policy" "inline" {
  name   = "${var.fn_name}-policy"
  role   = aws_iam_role.this.id
  policy = var.policy_json
}

# Allow writing logs
resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# The Lambda function
resource "aws_lambda_function" "this" {
  function_name    = var.fn_name
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.this.arn
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  environment {
    variables = var.env_vars
  }
}

# Short log retention to stay free
resource "aws_cloudwatch_log_group" "lg" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = var.log_retention_days
}

# Expose for callers
output "arn"  { value = aws_lambda_function.this.arn }
output "name" { value = aws_lambda_function.this.function_name }

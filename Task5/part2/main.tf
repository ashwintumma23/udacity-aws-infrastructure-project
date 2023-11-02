#################################################################
# Terraform file for Python Lambda Function Invocation
# AWS Secret Credentials are masked
#################################################################

# AWS Provider Information
provider "aws" {
  access_key = "AKIA46HTWUE4SBPDB4ZU"
  secret_key = "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"
  region     = var.aws_region
}

# Create Data Archive to be shipped
data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = var.lambda_output_path
}

# IAM Role for Lambda Function 
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM Policy for CloudWatch Access
resource "aws_iam_policy" "logs_policy" {
  name        = "logs_policy"
  path        = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "logs_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.logs_policy.arn
}

# Actual Lambda Function Resource Creation with its policies attached
resource "aws_lambda_function" "geeting_lambda" {
  function_name = var.lambda_name
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler = "greet_lambda.lambda_handler"
  runtime = "python3.8"
  role = aws_iam_role.lambda_execution_role.arn

  environment{
      variables = {
          greeting = "Ashwin Greeting Hello!"
      }
  }

  depends_on = [aws_iam_role_policy_attachment.logs_policy, aws_cloudwatch_log_group.lambda_log_group]
}

# Logs Retention Policy for Lambda Function Logs
# Days values here start with 0, 1, 3, 5, etc. 
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 1
}


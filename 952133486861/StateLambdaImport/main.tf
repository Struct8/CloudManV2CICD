terraform {
  required_version = ">= 1.0.0"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "cloudan-v2-cicd"
    key            = "952133486861/StateLambdaImport/main.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

# --- Main Cloud Provider ---
provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

### CATEGORY: IAM ###

data "aws_iam_policy_document" "lambda_function_TestImport_st_StateLambdaImport_doc" {
  statement {
    sid                             = "AllowWriteLogs"
    effect                          = "Allow"
    actions                         = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources                       = ["${aws_cloudwatch_log_group.TestImport.arn}:*"]
  }
}

resource "aws_iam_policy" "lambda_function_TestImport_st_StateLambdaImport" {
  name                              = "lambda_function_TestImport_st_StateLambdaImport"
  description                       = "Access Policy for TestImport"
  policy                            = data.aws_iam_policy_document.lambda_function_TestImport_st_StateLambdaImport_doc.json
}

resource "aws_iam_role" "role_lambda_TestImport" {
  name                              = "role_lambda_TestImport"
  assume_role_policy                = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
})
  tags                              = {
    "Name" = "role_lambda_TestImport"
    "State" = "StateLambdaImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_function_TestImport_st_StateLambdaImport_attach" {
  policy_arn                        = aws_iam_policy.lambda_function_TestImport_st_StateLambdaImport.arn
  role                              = aws_iam_role.role_lambda_TestImport.name
}




### CATEGORY: COMPUTE ###

data "archive_file" "archive__TestImport" {
  output_path                       = "${path.module}/_TestImport.zip"
  source_dir                        = "${path.module}/.external_modules/LambdaFiles/LambdaHub2"
  type                              = "zip"
}

resource "aws_lambda_function" "TestImport" {
  function_name                     = "TestImport"
  architectures                     = ["arm64"]
  filename                          = "${data.archive_file.archive__TestImport.output_path}"
  handler                           = "LambdaHub2.lambda_handler"
  memory_size                       = 3008
  publish                           = false
  reserved_concurrent_executions    = -1
  role                              = aws_iam_role.role_lambda_TestImport.arn
  runtime                           = "python3.13"
  source_code_hash                  = "${data.archive_file.archive__TestImport.output_base64sha256}"
  timeout                           = 30
  environment {
    variables                       = {
    "NAME" = "TestImport"
    "REGION" = "${data.aws_region.current.name}"
    "ACCOUNT" = "${data.aws_caller_identity.current.account_id}"
  }
  }
  tags                              = {
    "Name" = "TestImport"
    "State" = "StateLambdaImport"
    "CloudmanUser" = "Ricardo"
  }
  depends_on                        = [aws_iam_role_policy_attachment.lambda_function_TestImport_st_StateLambdaImport_attach]
}




### CATEGORY: MONITORING ###

resource "aws_cloudwatch_log_group" "TestImport" {
  name                              = "/aws/lambda/TestImport"
  log_group_class                   = "STANDARD"
  retention_in_days                 = 1
  skip_destroy                      = false
  tags                              = {
    "Name" = "TestImport"
    "State" = "StateLambdaImport"
    "CloudmanUser" = "Ricardo"
  }
}



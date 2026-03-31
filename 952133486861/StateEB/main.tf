terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "cloudan-v2-cicd"
    key            = "952133486861/StateEB/main.tfstate"
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

resource "aws_iam_role" "role_lambda_FunctionEB" {
  name                              = "role_lambda_FunctionEB"
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
    "Name" = "role_lambda_FunctionEB"
    "State" = "StateEB"
    "CloudmanUser" = "Ricardo"
  }
}




### CATEGORY: COMPUTE ###

resource "aws_lambda_function" "FunctionEB" {
  function_name                     = "FunctionEB"
  architectures                     = ["arm64"]
  filename                          = "teste"
  handler                           = "index.lambda_handler"
  memory_size                       = 3008
  publish                           = false
  reserved_concurrent_executions    = -1
  role                              = aws_iam_role.role_lambda_FunctionEB.arn
  runtime                           = "python3.13"
  timeout                           = 30
  environment {
    variables                       = {
    "NAME" = "FunctionEB"
    "REGION" = "${data.aws_region.current.name}"
    "ACCOUNT" = "${data.aws_caller_identity.current.account_id}"
  }
  }
  tags                              = {
    "Name" = "FunctionEB"
    "State" = "StateEB"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_lambda_permission" "perm_Rule_to_FunctionEB" {
  function_name                     = aws_lambda_function.FunctionEB.function_name
  statement_id                      = "perm_Rule_to_FunctionEB"
  principal                         = "events.amazonaws.com"
  action                            = "lambda:InvokeFunction"
  source_arn                        = aws_cloudwatch_event_rule.Rule.arn
}




### CATEGORY: INTEGRATION ###

resource "aws_cloudwatch_event_rule" "Rule" {
  name                              = "Rule"
  schedule_expression               = "rate(1 minute)"
  state                             = "ENABLED"
  tags                              = {
    "Name" = "Rule"
    "State" = "StateEB"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_cloudwatch_event_target" "Target" {
  arn                               = aws_lambda_function.FunctionEB.arn 
  rule                              = aws_cloudwatch_event_rule.Rule.name
}



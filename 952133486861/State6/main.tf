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
    key            = "952133486861/State6/main.tfstate"
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

resource "aws_iam_role" "role_lambda_Functionxxx" {
  name                              = "role_lambda_Functionxxx"
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
    "Name" = "role_lambda_Functionxxx"
    "State" = "State6"
    "CloudmanUser" = "CloudMan2"
  }
}




### CATEGORY: COMPUTE ###

data "archive_file" "archive_CloudMan_Functionxxx" {
  output_path                       = "${path.module}/CloudMan_Functionxxx.zip"
  source_dir                        = "${path.module}/.external_modules/CloudMan/LambdaFiles/Githubx"
  type                              = "zip"
}

resource "aws_lambda_function" "Functionxxx" {
  function_name                     = "Functionxxx"
  architectures                     = ["arm64"]
  filename                          = "${data.archive_file.archive_CloudMan_Functionxxx.output_path}"
  handler                           = "Githubx.lambda_handler"
  memory_size                       = 3008
  publish                           = false
  reserved_concurrent_executions    = -1
  role                              = aws_iam_role.role_lambda_Functionxxx.arn
  runtime                           = "python3.13"
  source_code_hash                  = "${data.archive_file.archive_CloudMan_Functionxxx.output_base64sha256}"
  timeout                           = 30
  environment {
    variables                       = {
    "NAME" = "Functionxxx"
    "REGION" = data.aws_region.current.name
    "ACCOUNT" = data.aws_caller_identity.current.account_id
  }
  }
  tags                              = {
    "Name" = "Functionxxx"
    "State" = "State6"
    "CloudmanUser" = "CloudMan2"
  }
}



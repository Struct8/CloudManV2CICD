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
    key            = "952133486861/State3ec2/main.tfstate"
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

resource "aws_iam_instance_profile" "profile_Instance" {
  name                              = "profile_Instance"
  role                              = aws_iam_role.role_ec2_Instance.name
  tags                              = {
    "Name" = "profile_Instance"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
}

data "aws_iam_policy_document" "instance_Instance_st_State3ec2_doc" {
  statement {
    sid                             = "AllowBucketLevelActions"
    effect                          = "Allow"
    actions                         = ["s3:DeleteObject", "s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:PutObject"]
    resources                       = ["*"]
  }
}

resource "aws_iam_policy" "instance_Instance_st_State3ec2" {
  name                              = "instance_Instance_st_State3ec2"
  description                       = "Access Policy for Instance"
  policy                            = data.aws_iam_policy_document.instance_Instance_st_State3ec2_doc.json
}

data "aws_iam_policy_document" "lambda_function_Function_st_State3ec2_doc" {
  statement {
    sid                             = "AllowBucketLevelActions"
    effect                          = "Allow"
    actions                         = ["s3:DeleteObject", "s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:PutObject"]
    resources                       = ["*"]
  }
}

resource "aws_iam_policy" "lambda_function_Function_st_State3ec2" {
  name                              = "lambda_function_Function_st_State3ec2"
  description                       = "Access Policy for Function"
  policy                            = data.aws_iam_policy_document.lambda_function_Function_st_State3ec2_doc.json
}

resource "aws_iam_role" "role_ec2_Instance" {
  name                              = "role_ec2_Instance"
  assume_role_policy                = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
})
  tags                              = {
    "Name" = "role_ec2_Instance"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_iam_role" "role_lambda_Function" {
  name                              = "role_lambda_Function"
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
    "Name" = "role_lambda_Function"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_iam_role_policy_attachment" "instance_Instance_st_State3ec2_attach" {
  policy_arn                        = aws_iam_policy.instance_Instance_st_State3ec2.arn
  role                              = aws_iam_role.role_ec2_Instance.name
}

resource "aws_iam_role_policy_attachment" "lambda_function_Function_st_State3ec2_attach" {
  policy_arn                        = aws_iam_policy.lambda_function_Function_st_State3ec2.arn
  role                              = aws_iam_role.role_lambda_Function.name
}




### CATEGORY: NETWORK ###

resource "aws_vpc" "VPC" {
  cidr_block                        = "10.0.0.0/16"
  instance_tenancy                  = "default"
  tags                              = {
    "Name" = "VPC"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "Subnet" {
  vpc_id                            = aws_vpc.VPC.id
  availability_zone                 = "us-east-1a"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "Subnet"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group" "instance_Instance_group" {
  name                              = "instance_Instance_group"
  vpc_id                            = aws_vpc.VPC.id
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "instance_Instance_group"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group_rule" "rule_instance_Instance_group_egress_all_protocols" {
  security_group_id                 = aws_security_group.instance_Instance_group.id
  cidr_blocks                       = ["0.0.0.0/0"]
  from_port                         = 0
  protocol                          = "-1"
  to_port                           = 0
  type                              = "egress"
}




### CATEGORY: STORAGE ###

resource "aws_s3_bucket" "my-bucket" {
  bucket                            = "my-bucket"
  force_destroy                     = false
  object_lock_enabled               = false
  tags                              = {
    "Name" = "my-bucket"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_s3_bucket_ownership_controls" "my-bucket_controls" {
  bucket                            = aws_s3_bucket.my-bucket.id
  rule {
    object_ownership                = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "my-bucket_block" {
  block_public_acls                 = true
  block_public_policy               = true
  bucket                            = aws_s3_bucket.my-bucket.id
  ignore_public_acls                = true
  restrict_public_buckets           = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my-bucket_configuration" {
  bucket                            = aws_s3_bucket.my-bucket.id
  expected_bucket_owner             = data.aws_caller_identity.current.account_id
  rule {
    bucket_key_enabled              = true
  }
}

resource "aws_s3_bucket_versioning" "my-bucket_versioning" {
  bucket                            = aws_s3_bucket.my-bucket.id
  versioning_configuration {
    mfa_delete                      = "Disabled"
    status                          = "Suspended"
  }
}




### CATEGORY: COMPUTE ###

data "aws_ami" "AMI_Data_Source_Instance" {
  most_recent                       = true
  owners                            = ["amazon"]
  filter {
    name                            = "name"
    values                          = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "Instance" {
  subnet_id                         = aws_subnet.Subnet.id
  ami                               = data.aws_ami.AMI_Data_Source_Instance.id
  associate_public_ip_address       = false
  iam_instance_profile              = aws_iam_instance_profile.profile_Instance.name
  instance_type                     = "t3.micro"
  user_data_base64                  = base64encode(<<-EOFUData
#!/bin/bash

# --- BEGIN CLOUDMAN VARIABLES ---
cat << 'EOFENV' > /etc/cloudman_env
a="b"
NAME="Instance"
REGION="${data.aws_region.current.name}"
ACCOUNT="${data.aws_caller_identity.current.account_id}"
AWS_S3_BUCKET_TARGET_NAME_0="my-bucket"
AWS_S3_BUCKET_TARGET_ARN_0="${aws_s3_bucket.my-bucket.arn}"
EOFENV
cat /etc/cloudman_env >> /etc/environment
sed 's/^/export /' /etc/cloudman_env > /etc/profile.d/cloudman_vars.sh
chmod +x /etc/profile.d/cloudman_vars.sh
chmod 644 /etc/cloudman_env
# --- END CLOUDMAN VARIABLES ---


EOFUData
)
  user_data_replace_on_change       = false
  vpc_security_group_ids            = [aws_security_group.instance_Instance_group.id]
  tags                              = {
    "Name" = "Instance"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
  depends_on                        = [aws_iam_role_policy_attachment.instance_Instance_st_State3ec2_attach]
}

resource "aws_lambda_function" "Function" {
  function_name                     = "Function"
  architectures                     = ["arm64"]
  filename                          = "teste"
  handler                           = "index.lambda_handler"
  memory_size                       = 3008
  publish                           = false
  reserved_concurrent_executions    = -1
  role                              = aws_iam_role.role_lambda_Function.arn
  runtime                           = "python3.13"
  timeout                           = 30
  environment {
    variables                       = {
    "NAME" = "Function"
    "REGION" = "${data.aws_region.current.name}"
    "ACCOUNT" = "${data.aws_caller_identity.current.account_id}"
    "AWS_S3_BUCKET_TARGET_NAME_0" = "my-bucket"
    "AWS_S3_BUCKET_TARGET_ARN_0" = "${aws_s3_bucket.my-bucket.arn}"
  }
  }
  tags                              = {
    "Name" = "Function"
    "State" = "State3ec2"
    "CloudmanUser" = "Ricardo"
  }
  depends_on                        = [aws_iam_role_policy_attachment.lambda_function_Function_st_State3ec2_attach]
}



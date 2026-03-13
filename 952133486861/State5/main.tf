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
    key            = "952133486861/State5/main.tfstate"
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

### CATEGORY: NETWORK ###

resource "aws_vpc" "VPC1" {
  cidr_block                        = "10.4.0.0/16"
  instance_tenancy                  = "default"
  tags                              = {
    "Name" = "VPC1"
    "State" = "State5"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "Subnet2" {
  vpc_id                            = aws_vpc.VPC1.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.4.0.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "Subnet2"
    "State" = "State5"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "Subnet3" {
  vpc_id                            = aws_vpc.VPC1.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.4.1.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "Subnet3"
    "State" = "State5"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group" "efs_file_system_EFS3_group" {
  name                              = "efs_file_system_EFS3_group"
  vpc_id                            = aws_vpc.VPC1.id
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "efs_file_system_EFS3_group"
    "State" = "State5"
    "CloudmanUser" = "Ricardo"
  }
}




### CATEGORY: STORAGE ###

resource "aws_efs_file_system" "EFS3" {
  availability_zone_name            = "us-east-1a"
  encrypted                         = true
  throughput_mode                   = "elastic"
  tags                              = {
    "Name" = "EFS3"
    "State" = "State5"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_efs_mount_target" "mt_EFS3_Subnet3" {
  file_system_id                    = aws_efs_file_system.EFS3.id
  subnet_id                         = aws_subnet.Subnet3.id
  security_groups                   = [aws_security_group.efs_file_system_EFS3_group.id]
}



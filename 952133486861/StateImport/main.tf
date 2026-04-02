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
    key            = "952133486861/StateImport/main.tfstate"
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

resource "aws_iam_instance_profile" "profile_test" {
  name                              = "profile_test"
  role                              = aws_iam_role.role_ec2_test.name
  tags                              = {
    "Name" = "profile_test"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_iam_role" "role_ec2_test" {
  name                              = "role_ec2_test"
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
    "Name" = "role_ec2_test"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}




### CATEGORY: NETWORK ###

resource "aws_vpc" "project-vpc" {
  cidr_block                        = "10.0.0.0/16"
  enable_dns_hostnames              = true
  enable_dns_support                = true
  instance_tenancy                  = "default"
  ipv6_cidr_block                   = "2600:1f18:55da:b600::/56"
  tags                              = {
    "Name" = "project-vpc"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "project-subnet-private1-us-east-1a" {
  vpc_id                            = aws_vpc.project-vpc.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.0.128.0/20"
  map_public_ip_on_launch           = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags                              = {
    "Name" = "project-subnet-private1-us-east-1a"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "project-subnet-private2-us-east-1b" {
  vpc_id                            = aws_vpc.project-vpc.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.0.144.0/20"
  map_public_ip_on_launch           = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags                              = {
    "Name" = "project-subnet-private2-us-east-1b"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "project-subnet-public1-us-east-1a" {
  vpc_id                            = aws_vpc.project-vpc.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.0.0.0/20"
  map_public_ip_on_launch           = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags                              = {
    "Name" = "project-subnet-public1-us-east-1a"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "project-subnet-public2-us-east-1b" {
  vpc_id                            = aws_vpc.project-vpc.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.0.16.0/20"
  map_public_ip_on_launch           = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags                              = {
    "Name" = "project-subnet-public2-us-east-1b"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_internet_gateway" "project-igw" {
  vpc_id                            = aws_vpc.project-vpc.id
  tags                              = {
    "Name" = "project-igw"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route" "aws_route_project_rtb_public_project_igw" {
  gateway_id                        = aws_internet_gateway.project-igw.id
  route_table_id                    = aws_route_table.project-rtb-public.id
  destination_cidr_block            = "0.0.0.0/0"
}

resource "aws_route_table" "project-rtb-private1-us-east-1a" {
  vpc_id                            = aws_vpc.project-vpc.id
  tags                              = {
    "Name" = "project-rtb-private1-us-east-1a"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route_table" "project-rtb-private2-us-east-1b" {
  vpc_id                            = aws_vpc.project-vpc.id
  tags                              = {
    "Name" = "project-rtb-private2-us-east-1b"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route_table" "project-rtb-public" {
  vpc_id                            = aws_vpc.project-vpc.id
  tags                              = {
    "Name" = "project-rtb-public"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_private1_us_east_1a_project_rtb_private1_us_east_1a" {
  route_table_id                    = aws_route_table.project-rtb-private1-us-east-1a.id
  subnet_id                         = aws_subnet.project-subnet-private1-us-east-1a.id
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_private2_us_east_1b_project_rtb_private2_us_east_1b" {
  route_table_id                    = aws_route_table.project-rtb-private2-us-east-1b.id
  subnet_id                         = aws_subnet.project-subnet-private2-us-east-1b.id
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_public1_us_east_1a_project_rtb_public" {
  route_table_id                    = aws_route_table.project-rtb-public.id
  subnet_id                         = aws_subnet.project-subnet-public1-us-east-1a.id
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_public2_us_east_1b_project_rtb_public" {
  route_table_id                    = aws_route_table.project-rtb-public.id
  subnet_id                         = aws_subnet.project-subnet-public2-us-east-1b.id
}

resource "aws_security_group" "instance_test_group" {
  name                              = "instance_test_group"
  vpc_id                            = aws_vpc.project-vpc.id
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "instance_test_group"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group_rule" "rule_instance_test_group_egress_all_protocols" {
  security_group_id                 = aws_security_group.instance_test_group.id
  cidr_blocks                       = ["0.0.0.0/0"]
  from_port                         = 0
  protocol                          = "-1"
  to_port                           = 0
  type                              = "egress"
}




### CATEGORY: COMPUTE ###

data "aws_ami" "AMI_Data_Source_test" {
  most_recent                       = true
  owners                            = ["amazon"]
  filter {
    name                            = "name"
    values                          = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "test" {
  subnet_id                         = aws_subnet.project-subnet-private1-us-east-1a.id
  ami                               = data.aws_ami.AMI_Data_Source_test.id
  associate_public_ip_address       = false
  ebs_optimized                     = true
  iam_instance_profile              = aws_iam_instance_profile.profile_test.name
  instance_type                     = "t4g.nano"
  private_ip                        = "10.0.130.110"
  user_data_base64                  = base64encode(<<-EOFUData
#!/bin/bash


EOFUData
)
  vpc_security_group_ids            = [aws_security_group.instance_test_group.id]
  cpu_options {
    core_count                      = 2
    threads_per_core                = 1
  }
  credit_specification {
    cpu_credits                     = "unlimited"
  }
  enclave_options {
    enabled                         = false
  }
  metadata_options {
    http_put_response_hop_limit     = 2
    http_tokens                     = "required"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                   = "ip-name"
  }
  root_block_device {
    encrypted                       = false
    iops                            = 3000
    throughput                      = 125
    volume_size                     = 8
    volume_type                     = "gp3"
  }
  tags                              = {
    "Name" = "test"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}



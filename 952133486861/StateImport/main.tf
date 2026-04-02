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

resource "aws_iam_instance_profile" "profile_Inst" {
  name                              = "profile_Inst"
  role                              = aws_iam_role.role_ec2_Inst.name
  tags                              = {
    "Name" = "profile_Inst"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_iam_role" "role_ec2_Inst" {
  name                              = "role_ec2_Inst"
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
    "Name" = "role_ec2_Inst"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}




### CATEGORY: NETWORK ###

resource "aws_vpc" "prj-vpc" {
  cidr_block                        = "10.0.0.0/16"
  enable_dns_hostnames              = true
  enable_dns_support                = true
  instance_tenancy                  = "default"
  tags                              = {
    "Name" = "prj-vpc"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "prj-subnet-private1-us-east-1a" {
  vpc_id                            = aws_vpc.prj-vpc.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.0.128.0/20"
  map_public_ip_on_launch           = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags                              = {
    "Name" = "prj-subnet-private1-us-east-1a"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "prj-subnet-private2-us-east-1b" {
  vpc_id                            = aws_vpc.prj-vpc.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.0.144.0/20"
  map_public_ip_on_launch           = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags                              = {
    "Name" = "prj-subnet-private2-us-east-1b"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "prj-subnet-public1-us-east-1a" {
  vpc_id                            = aws_vpc.prj-vpc.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.0.0.0/20"
  map_public_ip_on_launch           = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags                              = {
    "Name" = "prj-subnet-public1-us-east-1a"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "prj-subnet-public2-us-east-1b" {
  vpc_id                            = aws_vpc.prj-vpc.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.0.16.0/20"
  map_public_ip_on_launch           = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags                              = {
    "Name" = "prj-subnet-public2-us-east-1b"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_internet_gateway" "prj-igw" {
  vpc_id                            = aws_vpc.prj-vpc.id
  tags                              = {
    "Name" = "prj-igw"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route" "aws_route_prj_rtb_public_prj_igw" {
  gateway_id                        = aws_internet_gateway.prj-igw.id
  route_table_id                    = aws_route_table.prj-rtb-public.id
  destination_cidr_block            = "0.0.0.0/0"
}

resource "aws_route_table" "prj-rtb-private1-us-east-1a" {
  vpc_id                            = aws_vpc.prj-vpc.id
  tags                              = {
    "Name" = "prj-rtb-private1-us-east-1a"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route_table" "prj-rtb-private2-us-east-1b" {
  vpc_id                            = aws_vpc.prj-vpc.id
  tags                              = {
    "Name" = "prj-rtb-private2-us-east-1b"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route_table" "prj-rtb-public" {
  vpc_id                            = aws_vpc.prj-vpc.id
  tags                              = {
    "Name" = "prj-rtb-public"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route_table_association" "aws_route_table_association_prj_subnet_private1_us_east_1a_prj_rtb_private1_us_east_1a" {
  route_table_id                    = aws_route_table.prj-rtb-private1-us-east-1a.id
  subnet_id                         = aws_subnet.prj-subnet-private1-us-east-1a.id
}

resource "aws_route_table_association" "aws_route_table_association_prj_subnet_private2_us_east_1b_prj_rtb_private2_us_east_1b" {
  route_table_id                    = aws_route_table.prj-rtb-private2-us-east-1b.id
  subnet_id                         = aws_subnet.prj-subnet-private2-us-east-1b.id
}

resource "aws_route_table_association" "aws_route_table_association_prj_subnet_public1_us_east_1a_prj_rtb_public" {
  route_table_id                    = aws_route_table.prj-rtb-public.id
  subnet_id                         = aws_subnet.prj-subnet-public1-us-east-1a.id
}

resource "aws_route_table_association" "aws_route_table_association_prj_subnet_public2_us_east_1b_prj_rtb_public" {
  route_table_id                    = aws_route_table.prj-rtb-public.id
  subnet_id                         = aws_subnet.prj-subnet-public2-us-east-1b.id
}

resource "aws_security_group" "instance_Inst_group" {
  name                              = "instance_Inst_group"
  vpc_id                            = aws_vpc.prj-vpc.id
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "instance_Inst_group"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group_rule" "rule_instance_Inst_group_egress_all_protocols" {
  security_group_id                 = aws_security_group.instance_Inst_group.id
  cidr_blocks                       = ["0.0.0.0/0"]
  from_port                         = 0
  protocol                          = "-1"
  to_port                           = 0
  type                              = "egress"
}




### CATEGORY: COMPUTE ###

resource "aws_instance" "Inst" {
  subnet_id                         = aws_subnet.subnet-0e7556fa994ef548d.id
  ami                               = aws_ami.ami-07588980091994c40.id
  associate_public_ip_address       = false
  availability_zone                 = "us-east-1a"
  ebs_optimized                     = true
  iam_instance_profile              = aws_iam_instance_profile.profile_Inst.name
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                     = "t4g.nano"
  private_ip                        = "10.0.142.166"
  user_data_base64                  = base64encode(<<-EOFUData
#!/bin/bash


EOFUData
)
  vpc_security_group_ids            = [aws_security_group.sg-00e1c5d428577c30f.id]
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
  instance_market_options {
    market_type                     = "spot"
    spot_options {
      instance_interruption_behavior = "terminate"
      max_price                     = "0.004200"
      spot_instance_type            = "one-time"
    }
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
    "Name" = "Inst"
    "State" = "StateImport"
    "CloudmanUser" = "Ricardo"
  }
  tags_all {
    Name                            = "Inst"
  }
}



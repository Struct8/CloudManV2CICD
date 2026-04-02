terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "cloudan-v2-cicd"
    key    = "952133486861/StateImport/main.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_internet_gateway" "project-igw" {
  tags = {
    Name = "project-igw"
  }
  vpc_id = "vpc-0e735273387d9cd33"
}

resource "aws_route" "aws_route_project_rtb_public_project_igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "igw-0046474b9e40e42e6"
  route_table_id = "rtb-002daa3181f1f3270"
}

resource "aws_route_table" "project-rtb-private1-us-east-1a" {
  tags = {
    Name = "project-rtb-private1-us-east-1a"
  }
  vpc_id = "vpc-0e735273387d9cd33"
}

resource "aws_route_table" "project-rtb-private2-us-east-1b" {
  tags = {
    Name = "project-rtb-private2-us-east-1b"
  }
  vpc_id = "vpc-0e735273387d9cd33"
}

resource "aws_route_table" "project-rtb-public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0046474b9e40e42e6"
  }
  tags = {
    Name = "project-rtb-public"
  }
  vpc_id = "vpc-0e735273387d9cd33"
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_private1_us_east_1a_project_rtb_private1_us_east_1a" {
  route_table_id = "rtb-06ceb1830caf34d71"
  subnet_id = "subnet-005f49cb541da34b1"
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_private2_us_east_1b_project_rtb_private2_us_east_1b" {
  route_table_id = "rtb-067b61e777aa8567f"
  subnet_id = "subnet-07c336cc23f419775"
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_public1_us_east_1a_project_rtb_public" {
  route_table_id = "rtb-002daa3181f1f3270"
  subnet_id = "subnet-0ee62a9aa3a77fe7a"
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_public2_us_east_1b_project_rtb_public" {
  route_table_id = "rtb-002daa3181f1f3270"
  subnet_id = "subnet-055f68110a683040b"
}

resource "aws_subnet" "project-subnet-private1-us-east-1a" {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.128.0/20"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-private1-us-east-1a"
  }
  vpc_id = "vpc-0e735273387d9cd33"
}

resource "aws_subnet" "project-subnet-private2-us-east-1b" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.144.0/20"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-private2-us-east-1b"
  }
  vpc_id = "vpc-0e735273387d9cd33"
}

resource "aws_subnet" "project-subnet-public1-us-east-1a" {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/20"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-public1-us-east-1a"
  }
  vpc_id = "vpc-0e735273387d9cd33"
}

resource "aws_subnet" "project-subnet-public2-us-east-1b" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.16.0/20"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-public2-us-east-1b"
  }
  vpc_id = "vpc-0e735273387d9cd33"
}

resource "aws_vpc" "project-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags = {
    Name = "project-vpc"
  }
}


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

resource "aws_instance" "testi" {
  ami = "ami-08b64331b44a4d621"
  associate_public_ip_address = false
  availability_zone = "us-east-1a"
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    core_count = 2
    threads_per_core = 1
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  ebs_optimized = true
  enclave_options {
    enabled = false
  }
  id = "i-042ef356f17292d25"
  instance_type = "t4g.nano"
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint = "enabled"
    http_protocol_ipv6 = "disabled"
    http_put_response_hop_limit = 2
    http_tokens = "required"
    instance_metadata_tags = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type = "ip-name"
  }
  private_ip = "10.0.134.187"
  region = "us-east-1"
  root_block_device {
    delete_on_termination = true
    encrypted = false
    iops = 3000
    throughput = 125
    volume_size = 8
    volume_type = "gp3"
  }
  subnet_id = "subnet-0c615d34d43cddbb8"
  tags = {
    Name = "testi"
  }
  tags_all = {
    Name = "testi"
  }
  vpc_security_group_ids = ["sg-094d6efdfe4e718d5"]
}

resource "aws_internet_gateway" "project-igw" {
  tags = {
    Name = "project-igw"
  }
  vpc_id = "vpc-0aa413081b1a16aa1"
}

resource "aws_route" "project-rtb-public_rtb_02aa4bbd6ae0d2850_0_0_0_0_0" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "igw-06e86779d555b6bcf"
  route_table_id = "rtb-02aa4bbd6ae0d2850"
}

resource "aws_route_table" "project-rtb-private1-us-east-1a" {
  tags = {
    Name = "project-rtb-private1-us-east-1a"
  }
  vpc_id = "vpc-0aa413081b1a16aa1"
}

resource "aws_route_table" "project-rtb-private2-us-east-1b" {
  tags = {
    Name = "project-rtb-private2-us-east-1b"
  }
  vpc_id = "vpc-0aa413081b1a16aa1"
}

resource "aws_route_table" "project-rtb-public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-06e86779d555b6bcf"
  }
  tags = {
    Name = "project-rtb-public"
  }
  vpc_id = "vpc-0aa413081b1a16aa1"
}

resource "aws_subnet" "project-subnet-private1-us-east-1a" {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.128.0/20"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-private1-us-east-1a"
  }
  vpc_id = "vpc-0aa413081b1a16aa1"
}

resource "aws_subnet" "project-subnet-private2-us-east-1b" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.144.0/20"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-private2-us-east-1b"
  }
  vpc_id = "vpc-0aa413081b1a16aa1"
}

resource "aws_subnet" "project-subnet-public1-us-east-1a" {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/20"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-public1-us-east-1a"
  }
  vpc_id = "vpc-0aa413081b1a16aa1"
}

resource "aws_subnet" "project-subnet-public2-us-east-1b" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.16.0/20"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-public2-us-east-1b"
  }
  vpc_id = "vpc-0aa413081b1a16aa1"
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


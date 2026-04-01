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
  vpc_id = "vpc-0dae32a7f2c046aa2"
}

resource "aws_route" "aws_route_project_rtb_public_project_igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "igw-06984605e0f0d90b0"
  route_table_id = "rtb-09a0561cd983e8530"
}

resource "aws_route_table" "project-rtb-private1-us-east-1a" {
  route {
    egress_only_gateway_id = "eigw-00b92ae3cadc5d1d1"
    ipv6_cidr_block = "::/0"
  }
  tags = {
    Name = "project-rtb-private1-us-east-1a"
  }
  vpc_id = "vpc-0dae32a7f2c046aa2"
}

resource "aws_route_table" "project-rtb-private2-us-east-1b" {
  route {
    egress_only_gateway_id = "eigw-00b92ae3cadc5d1d1"
    ipv6_cidr_block = "::/0"
  }
  tags = {
    Name = "project-rtb-private2-us-east-1b"
  }
  vpc_id = "vpc-0dae32a7f2c046aa2"
}

resource "aws_route_table" "project-rtb-public" {
  route {
    gateway_id = "igw-06984605e0f0d90b0"
    ipv6_cidr_block = "::/0"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-06984605e0f0d90b0"
  }
  tags = {
    Name = "project-rtb-public"
  }
  vpc_id = "vpc-0dae32a7f2c046aa2"
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_private1_us_east_1a_project_rtb_private1_us_east_1a" {
  route_table_id = "rtb-0a43b784cd4a3ca78"
  subnet_id = "subnet-02266d6c27377d5cc"
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_private2_us_east_1b_project_rtb_private2_us_east_1b" {
  route_table_id = "rtb-0f3a93563ec043779"
  subnet_id = "subnet-0748f1f18048924e9"
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_public1_us_east_1a_project_rtb_public" {
  route_table_id = "rtb-09a0561cd983e8530"
  subnet_id = "subnet-0bf33e81c0ccc51d4"
}

resource "aws_route_table_association" "aws_route_table_association_project_subnet_public2_us_east_1b_project_rtb_public" {
  route_table_id = "rtb-09a0561cd983e8530"
  subnet_id = "subnet-0e5baa41a766fd249"
}

resource "aws_subnet" "project-subnet-private1-us-east-1a" {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.128.0/20"
  ipv6_cidr_block = "2600:1f18:32bb:b602::/64"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-private1-us-east-1a"
  }
  vpc_id = "vpc-0dae32a7f2c046aa2"
}

resource "aws_subnet" "project-subnet-private2-us-east-1b" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.144.0/20"
  ipv6_cidr_block = "2600:1f18:32bb:b603::/64"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-private2-us-east-1b"
  }
  vpc_id = "vpc-0dae32a7f2c046aa2"
}

resource "aws_subnet" "project-subnet-public1-us-east-1a" {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/20"
  ipv6_cidr_block = "2600:1f18:32bb:b600::/64"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-public1-us-east-1a"
  }
  vpc_id = "vpc-0dae32a7f2c046aa2"
}

resource "aws_subnet" "project-subnet-public2-us-east-1b" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.16.0/20"
  ipv6_cidr_block = "2600:1f18:32bb:b601::/64"
  map_public_ip_on_launch = false
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    Name = "project-subnet-public2-us-east-1b"
  }
  vpc_id = "vpc-0dae32a7f2c046aa2"
}

resource "aws_vpc" "project-vpc" {
  assign_generated_ipv6_cidr_block = true
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  ipv6_cidr_block_network_border_group = "us-east-1"
  tags = {
    Name = "project-vpc"
  }
}


terraform {
  backend "s3" {
    bucket = "cloudan-v2-cicd"
    key    = "952133486861/StateImport/main.tfstate"
    region = "us-east-1"
  }
}

import {
  to = aws_subnet.project-subnet-public1-us-east-1a
  id = "subnet-0ee62a9aa3a77fe7a"
}

import {
  to = aws_internet_gateway.project-igw
  id = "igw-0046474b9e40e42e6"
}

import {
  to = aws_subnet.project-subnet-public2-us-east-1b
  id = "subnet-055f68110a683040b"
}

import {
  to = aws_vpc.project-vpc
  id = "vpc-0e735273387d9cd33"
}

import {
  to = aws_subnet.project-subnet-private2-us-east-1b
  id = "subnet-07c336cc23f419775"
}

import {
  to = aws_subnet.project-subnet-private1-us-east-1a
  id = "subnet-005f49cb541da34b1"
}

import {
  to = aws_route_table.project-rtb-public
  id = "rtb-002daa3181f1f3270"
}

import {
  to = aws_route.project-rtb-public_rtb_002daa3181f1f3270_0_0_0_0_0
  id = "rtb-002daa3181f1f3270_0.0.0.0/0"
}

import {
  to = aws_route_table_association.project-rtb-public_rtbassoc_0d8e4e60017609f85
  id = "rtbassoc-0d8e4e60017609f85"
}

import {
  to = aws_route_table_association.project-rtb-public_rtbassoc_0d21058cd4301d384
  id = "rtbassoc-0d21058cd4301d384"
}

import {
  to = aws_route_table.project-rtb-private2-us-east-1b
  id = "rtb-067b61e777aa8567f"
}

import {
  to = aws_route_table_association.project-rtb-private2-us-east-1b_rtbassoc_02c2129bb565fcc9e
  id = "rtbassoc-02c2129bb565fcc9e"
}

import {
  to = aws_route_table.project-rtb-private1-us-east-1a
  id = "rtb-06ceb1830caf34d71"
}

import {
  to = aws_route_table_association.project-rtb-private1-us-east-1a_rtbassoc_0070c7fe3d7b2db2f
  id = "rtbassoc-0070c7fe3d7b2db2f"
}



provider "aws" {
  region     = "us-east-2"
}

# This will store the statefile in s3 bucket
terraform {
  backend "s3" {
    bucket = "kenstatebucket2022"
    key    = "terraform.tfstate"
    dynamodb_table = "terraform-lock"
    region = "us-east-2"
  }
}

# This will provision ec2 using a module
module "my_ec2" {
  source = "./ec2-module"
  instance_type = "t2.small"
}


#This will provision VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

#This will provision a Security Group
resource "aws_security_group" "mysg" {
  description = "Allow HTTPS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id
  
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysecgroup"
  }
}


provider "aws" {
  region = "us-east-2"
}

## Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = var.cidr_blocks[0]
  tags = {
    Name = "production"
  }
}

## Create a subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = var.cidr_blocks[1]
  availability_zone = "us-east-2a"

  tags = {
    Name = var.environment
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  availability_zone = "us-east-2a"
  cidr_block        = var.cidr_blocks[2]

  tags = {
    Name = "prod-subnet-2"
  }
}

data "aws_vpc" "existing_vpc" {
  default =  true
}

variable "cidr_blocks" {
  description = "cidr blocks for vpc and subnets"
  type = list(string)
}

variable "environment" {
  description = "deployment environment"
}

output "vpc-id" {
  value = aws_vpc.prod-vpc.id
}

output "vpc-subnet" {
  value = aws_subnet.subnet-1.id
}

# variable "cidr_block" {
#   description = "cidr blocks for vpc and subnets"
#   type = list(object({
#       cidr_block = string,
#       name = string
#   }))
# }

# variable "subnet_cidr_block" {
#   description = "subnet cidr block"
# }

# variable "vpc_cidr_block" {
#   description = "subnet cidr block"
# }


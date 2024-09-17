## The service what we are going to create should be kept in main file

resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.cidr_block
  tags = {
    Name = var.vpc_config.name
  }
}

resource "aws_subnet" "main" {
  vpc_id   = aws_vpc.main.id
  for_each = var.subnet_config ## key={cidr, az} each.key each.value 

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

locals {
  public_subnet = {
    # key ={}, if public is true in subnet_config
    for key, config in var.subnet_config : key => config if config.public
  }
  private_subnet = {
    # key ={}, if public is true in subnet_config
    for key, config in var.subnet_config : key => config if !config.public
  }
}
# Internet gateway, if there is atleast one public subnet

resource "aws_internet_gateway" "main" { # > Internet gateway is associated with VPC, likewise check which mode or service require which resources..
  vpc_id = aws_vpc.main.id
  count  = length(local.public_subnet) > 0 ? 1 : 0 ## using Terinary operator, we can use "if-else" function in one line, and using ternary operator, we can create only one Internet-Gateway, inspite of whatever the number of Public-Subnet been created "greater than 1"
}

## Routing Table
resource "aws_route_table" "main" {
  count  = length(local.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }
}

resource "aws_route_table_association" "main" {
  for_each = local.public_subnet ## public_subnet = {} , private_subnet={}

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[0].id
}

# terraform apply
# Plan: 6 to add, 0 to change, 0 to destroy.
## Till now we created
# 1 - VPC
# 2 - SUbnet (1-Public, 1-Private)
# 1 - IGW
# 1 - Routing Table
# 1 - Routing Table Association (1-public Subnet Association)
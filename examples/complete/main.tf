provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./module/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "my_test_vpc"
  }

  subnet_config = {
    #key={cidr, az}
    public_subnet1 = {
      cidr_block = "10.0.0.0/24"
      az         = "ap-south-1a"
      public     = true
    }
    public_subnet2 = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1a"
      public     = true
    }

    private_subnet = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1b"
    }
  }
}

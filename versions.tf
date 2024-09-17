## "To get the versions of terraform and Name of VPC from user"

terraform {

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.60.0"
    }
  }
}

provider "aws" {
  # Configuration options ## can ention other properties like region, s3, etc..
  region = "ap-south-1"
}

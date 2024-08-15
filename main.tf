terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.16"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "remote-state-acics"
    key            = "terraformstate/state-bucket"
    dynamodb_table = "remote-state-lock-acics"
    region         = "eu-west-1"
    encrypt        = true
  }

}

provider "aws" {
  region = var.default_region

}
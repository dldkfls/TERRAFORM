terraform {
  backend "s3" {
    bucket  = "alin-terraform-state-bucket"
    key     = "100_network/102_network_gw/terraform.tfstate"
    region  = "ap-northeast-2"
    profile = "Administrator-471627162277"   
  }
}

terraform {
  required_providers {
    aws       = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
    region  = "ap-northeast-2"
    profile = "Administrator-471627162277"
}

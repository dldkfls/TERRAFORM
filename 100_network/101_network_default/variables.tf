###############################################################################
# Region
################################################################################
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "azs" {
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

###############################################################################
# Name
################################################################################
variable "vpc_name" {
    type      = string
    default   = "alin-test-vpc"
}
variable "public_subnet_name" {
    type      = string
    default   = "alin-test-public-subnet"
}

variable "private_compute_subnet_name" {
    type      = string
    default   = "alin-test-private_compute-subnet"
}

variable "private_db_subnet_name" {
    type      = string
    default   = "alin-test-private_db-subnet"
}


###############################################################################
# CIDR
################################################################################
variable "vpc_cidr" {
    type      = string
    default   = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
    type      = list(string)
    default   = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "private_compute_subnet_cidr" {
    type      = list(string)
    default   = ["172.16.3.0/24", "172.16.4.0/24"]
}

variable "private_db_subnet_cidr" {
    type      = list(string)
    default   = ["172.16.5.0/24", "172.16.6.0/24"]
}


###############################################################################
# Tag
################################################################################

variable "default_tag" {
    type      = string
    default   = "terraform"
}
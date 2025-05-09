
###############################################################################
# VPC
################################################################################
resource "aws_vpc" "main" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = "default"
    tags             = merge({ "Name" = "${var.vpc_name}" },
                             {"key" = "${var.default_tag}"}
                             )
}

################################################################################
# Publiс Subnets
################################################################################
resource "aws_subnet" "public" {
    count                   = local.create_public_subnets ? length(var.azs) : 0 
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidr[count.index]
    availability_zone       = var.azs[count.index]
    map_public_ip_on_launch = true
    tags                    = merge({ "Name" = "${var.public_subnet_name}" },
                                    {"key" = "${var.default_tag}"}
                                    )
}

################################################################################
# Private Subnets - Compute
################################################################################
resource "aws_subnet" "compute_private" {
    count             = local.create_private_compute_subnets ? length(var.azs) : 0 
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_compute_subnet_cidr[count.index]
    availability_zone = var.azs[count.index]
    tags              = merge({ "Name" = "${var.private_compute_subnet_name}" },
                              {"key" = "${var.default_tag}"},
                              {"eks" = "${var.default_tag}"}
                              )
}

################################################################################
# Private Subnets - DB
################################################################################
resource "aws_subnet" "db_private" {
    count             = local.create_private_db_subnets ? length(var.azs) : 0 
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_db_subnet_cidr[count.index]
    availability_zone = var.azs[count.index]
    tags              = merge({ "Name" = "${var.private_db_subnet_name}" },
                              {"key" = "${var.default_tag}"}
                              )
}
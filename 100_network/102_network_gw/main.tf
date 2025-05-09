################################################################################
# Existing Resource
################################################################################
data "terraform_remote_state" "network_default" {
  backend   = "s3"
  config    = {
    bucket  = "alin-terraform-state-bucket"
    key     = "100_network/101_network_default/terraform.tfstate"
    region  = "ap-northeast-2"
    profile = "Administrator-471627162277" 
  }
}


################################################################################
# IGW
################################################################################
resource "aws_internet_gateway" "igw" {
    vpc_id =  data.terraform_remote_state.network_default.outputs.vpc_id
    tags   = merge({ "Name" = "${var.igw_name}" },
                   {"key" = "${var.default_tag}"}
                   )

}


################################################################################
# NGW
################################################################################
resource "aws_eip" "nat" {
    tags = merge({ "Name" = "${var.eip_name}" },
                 {"key" = "${var.default_tag}"}
                 )

}

resource "aws_nat_gateway" "ngw" {
  subnet_id     =  data.terraform_remote_state.network_default.outputs.all_subnet_ids.public[0]
  allocation_id = aws_eip.nat.id
  depends_on    = [aws_eip.nat]
    tags        = merge({ "Name" = "${var.ngw_name}" },
                        {"key" = "${var.default_tag}"}
                       )
}

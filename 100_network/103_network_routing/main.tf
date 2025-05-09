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

data "terraform_remote_state" "network_gw" {
  backend   = "s3"
  config    = {
    bucket  = "alin-terraform-state-bucket"
    key     = "100_network/102_network_gw/terraform.tfstate"
    region  = "ap-northeast-2"
    profile = "Administrator-471627162277" 
  }
}

################################################################################
# Public Route Table
################################################################################
resource "aws_route_table" "public" {
    vpc_id         = data.terraform_remote_state.network_default.outputs.vpc_id
    route {
        cidr_block = var.igw_cidr
        gateway_id = data.terraform_remote_state.network_gw.outputs.igw_id
        }
    tags           = merge({ "Name" = "${var.public_rt_name}" },
                           {"key" = "${var.default_tag}"}
                           )
}

resource "aws_route_table_association" "public" {
    count          = length(data.terraform_remote_state.network_default.outputs.all_subnet_ids.public)
    subnet_id      = data.terraform_remote_state.network_default.outputs.all_subnet_ids.public[count.index]
    route_table_id = aws_route_table.public.id
}

################################################################################
# Private Route Table
################################################################################
resource "aws_route_table" "private" {
  count        = length(data.terraform_remote_state.network_default.outputs.all_subnet_ids.compute)
  vpc_id       = data.terraform_remote_state.network_default.outputs.vpc_id
  route {
    cidr_block = var.ngw_cidr
    gateway_id = data.terraform_remote_state.network_gw.outputs.ngw_id
    }
  tags         = merge({"Name" = "${var.private_rt_name}"},
                       {"key" = "${var.default_tag}"}
                       )
}

resource "aws_route_table_association" "private_compute" {
  count          = length(data.terraform_remote_state.network_default.outputs.all_subnet_ids.compute)
  subnet_id      = data.terraform_remote_state.network_default.outputs.all_subnet_ids.compute[count.index]
  route_table_id = aws_route_table.private[count.index].id
}
resource "aws_route_table_association" "private_db" {
  count          = length(data.terraform_remote_state.network_default.outputs.all_subnet_ids.db)
  subnet_id      = data.terraform_remote_state.network_default.outputs.all_subnet_ids.db[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

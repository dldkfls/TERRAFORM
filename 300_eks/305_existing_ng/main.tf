################################################################################
# Existing Resource
################################################################################
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["inc-sandbox-2-vpc"]  
  }
}

data "aws_subnets" "existing_subnets" {
  filter {
    name   = "tag:Name"
    values = ["inc-sandbox-2-sub-private-*"] 
  }
}
data "terraform_remote_state" "eks_cluster" {
  backend   = "s3"
  config    = {
    bucket  = "alin-terraform-state-bucket"
    key     = "800_eks_karpenter/801_eks_all/terraform.tfstate"
    region  = "ap-northeast-2"
    profile = "Administrator-471627162277" 
  }
}


resource "aws_eks_node_group" "eks_ng" {
  cluster_name    = data.terraform_remote_state.eks_cluster.outputs.eks_cluster_name
  node_group_name = var.eks_ng_name
  instance_types  = [var.eks_ng_type]
  node_role_arn   = var.eks_ng_role_arn
  subnet_ids              = data.aws_subnets.existing_subnets.ids
  

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

}

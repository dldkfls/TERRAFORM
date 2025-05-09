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


data "terraform_remote_state" "eks_cluster" {
  backend   = "s3"
  config    = {
    bucket  = "alin-terraform-state-bucket"
    key     = "300_eks/301_eks_cluster/terraform.tfstate"
    region  = "ap-northeast-2"
    profile = "Administrator-471627162277" 
  }
}


resource "aws_eks_node_group" "eks_ng" {
  cluster_name    = data.terraform_remote_state.eks_cluster.outputs.eks_cluster_name
  node_group_name = var.eks_ng_name
  instance_types  = [var.eks_ng_type]
  node_role_arn   = var.eks_ng_role_arn
  subnet_ids = [for subnet_id in data.terraform_remote_state.network_default.outputs.all_subnet_ids.compute : subnet_id]
  

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

}

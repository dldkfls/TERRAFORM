################################################################################
# Existing Resource
################################################################################
data "terraform_remote_state" "network_default" {
  backend = "s3"
  config = {
    bucket = "alin-terraform-state-bucket"
    key    = "100_network/101_network_default/terraform.tfstate"
    region = "ap-northeast-2"
    profile = "Administrator-471627162277" 
  }
}

###############################################################################
# EKS Cluster
################################################################################
resource "aws_eks_cluster" "eks_cluster" {
  name         = var.eks_cluster_name
  role_arn     = var.eks_cluster_role_arn
  version      = var.eks_version
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = false
    subnet_ids = [for subnet_id in data.terraform_remote_state.network_default.outputs.all_subnet_ids.compute : subnet_id]
  }

  tags         = merge({ "Name" = "${var.eks_cluster_name}" },
                       {"key" = "${var.default_tag}"}
                       )
}

###############################################################################
# EKS Add-on
################################################################################
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = var.eks_cluster_name
  addon_name    = "vpc-cni"
  addon_version = var.vpc_cni_version
  depends_on    = [aws_eks_cluster.eks_cluster]

}

resource "aws_eks_addon" "coredns" {
  cluster_name  = var.eks_cluster_name
  addon_name    = "coredns"
  addon_version = var.coredns_version
  depends_on    = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = var.eks_cluster_name
  addon_name    = "kube-proxy"
  addon_version = var.kube_proxy_version
  depends_on    = [aws_eks_cluster.eks_cluster]

}
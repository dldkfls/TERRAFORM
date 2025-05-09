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

###############################################################################
# EKS Cluster
###############################################################################
resource "aws_eks_cluster" "eks_cluster" {
  name         = var.eks_cluster_name
  role_arn     = var.eks_cluster_role_arn
  version      = var.eks_version
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    subnet_ids = [for subnet_id in data.terraform_remote_state.network_default.outputs.all_subnet_ids.compute : subnet_id]
  }

  tags         = merge({ "Name" = "${var.eks_cluster_name}" },
                       {"key" = "${var.default_tag}"}
                       )
}

###############################################################################
# OIDC Provider
###############################################################################
data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url             = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
  depends_on      = [aws_eks_cluster.eks_cluster]

}


###############################################################################
# EKS Add-on
###############################################################################
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
  depends_on    = [aws_eks_node_group.eks_ng]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = var.eks_cluster_name
  addon_name    = "kube-proxy"
  addon_version = var.kube_proxy_version
  depends_on    = [aws_eks_cluster.eks_cluster]

}

###############################################################################
# EKS Node Group
###############################################################################
resource "aws_eks_node_group" "eks_ng" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.eks_ng_name
  instance_types  = [var.eks_ng_type]
  node_role_arn   = var.eks_ng_role_arn
  subnet_ids      = [for subnet_id in data.terraform_remote_state.network_default.outputs.all_subnet_ids.compute : subnet_id]
  depends_on      = [aws_eks_cluster.eks_cluster]
  

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }


}

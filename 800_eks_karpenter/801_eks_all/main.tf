################################################################################
# Existing Resource
################################################################################
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.existing_vpc]  #
  }
}

data "aws_subnets" "existing_subnets" {
  filter {
    name   = "tag:Name"
    values = [var.existing_subnets] 
  }
}

###############################################################################
# EKS Cluster
###############################################################################
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = var.eks_version
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    subnet_ids              = data.aws_subnets.existing_subnets.ids
  }

  tags = merge(
    { "Name" = var.eks_cluster_name },
    { "key"  = var.default_tag }
  )
}

###############################################################################
# OIDC Provider
###############################################################################
data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
  depends_on      = [aws_eks_cluster.eks_cluster]
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

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = var.eks_cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = var.pod_identity_agent_version
  depends_on    = [aws_eks_node_group.eks_ng]
}

###############################################################################
# EKS Node Group
###############################################################################
resource "aws_eks_node_group" "eks_ng" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.eks_ng_name
  instance_types  = [var.eks_ng_type]
  node_role_arn   = var.eks_ng_role_arn
  subnet_ids      = data.aws_subnets.existing_subnets.ids
  depends_on      = [aws_eks_cluster.eks_cluster]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
}

###############################################################################
# EKS Pod Access Entry
###############################################################################
resource "aws_eks_access_entry" "admin_entry" {
  cluster_name = var.eks_cluster_name
  principal_arn = var.arn

  type = "STANDARD"
}
resource "aws_eks_access_policy_association" "admin_policy1" {
  cluster_name  = var.eks_cluster_name
  principal_arn = var.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin_entry]
}

resource "aws_eks_access_policy_association" "admin_policy2" {
  cluster_name  = var.eks_cluster_name
  principal_arn = var.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin_entry]
}

###############################################################################
# EKS Pod Identity associations
###############################################################################
resource "aws_eks_pod_identity_association" "pod_identity" {
  depends_on    = [aws_eks_node_group.eks_ng]
  cluster_name    = var.eks_cluster_name
  namespace       = "kube-system"
  service_account = "karpenter"
  role_arn        = var.karpenter_role
}

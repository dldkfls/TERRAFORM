###############################################################################
# Name
################################################################################
variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "alin-test-cluster"
}

###############################################################################
# ARN
################################################################################
variable "eks_cluster_role_arn" {
  description = "EKS Cluster ARN"
  type        = string
  default     = "arn:aws:iam::471627162277:role/alin-tf-eks-cluster-iam-role"
}


###############################################################################
# EKS Version
################################################################################
variable "eks_version" {
  description = "EKS Cluster Version"
  type        = string
  default     = "1.32"
}

variable "vpc_cni_version" {
  type    = string
  default = "v1.19.2-eksbuild.1"
}

variable "coredns_version" {
  type    = string
  default = "v1.11.4-eksbuild.2"

}

variable "kube_proxy_version" {
  type    = string
  default = "v1.32.0-eksbuild.2"
  
}

###############################################################################
# Tag
################################################################################
variable "default_tag" {
    type      = string
    default   = "terraform"
}

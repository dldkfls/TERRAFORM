###############################################################################
# Name
################################################################################
variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "alin-test-cluster-132"
}

variable "eks_ng_name" {
    description = "EKS Node Group Name"
    type        = string
    default     = "alin-test-eks-ng-132"
}

variable "existing_vpc" {
  description = "Existing_vpc"
  type        = string
  default     = "inc-sandbox-2-vpc"
}

variable "existing_subnets" {
  description = "Existing_subnets"
  type        = string
  default     = "inc-sandbox-2-sub-private-*"
}

###############################################################################
# ARN
################################################################################
variable "eks_cluster_role_arn" {
  description = "EKS Cluster ARN"
  type        = string
  default     = "arn:aws:iam::471627162277:role/alin-tf-eks-cluster-iam-role"
}

variable "eks_ng_role_arn" {
    type    = string
    default = "arn:aws:iam::471627162277:role/alin-tf-eks-ng-iam-role"
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
  default = "v1.19.2-eksbuild.5"
}

variable "coredns_version" {
  type    = string
  default = "v1.11.4-eksbuild.2"

}

variable "kube_proxy_version" {
  type    = string
  default = "v1.32.0-eksbuild.2"
  
}
variable "eks_ng_type"{
    type    = string
    default = "t3.medium"
}

variable "max_size"{
    type    = string
    default = "2"
}

variable "min_size"{
    type    = string
    default = "1"
}

variable "desired_size"{
    type    = string
    default = "1"
}
###############################################################################
# Tag
################################################################################
variable "default_tag" {
    type      = string
    default   = "terraform"
}

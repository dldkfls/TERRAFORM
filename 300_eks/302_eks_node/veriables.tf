variable "eks_ng_name" {
    description = "EKS Node Group Name"
    type        = string
    default     = "alin-test-eks-ng"
}

variable "eks_ng_type"{
    type    = string
    default = "t3.medium"
}

###############################################################################
# ARN
################################################################################
variable "eks_ng_role_arn" {
    type    = string
    default = "arn:aws:iam::471627162277:role/alin-tf-eks-ng-iam-role"
}
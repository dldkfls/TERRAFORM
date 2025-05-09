
variable "karpenter_version" {
    type        = string
    default = "1.3.3"
}


variable "karpenter_namespace" {
    type        = string
    default = "kube-system"
}

variable "karpenter_role" {
    type        = string
    default = "	arn:aws:iam::471627162277:role/seojin-karpenter-test"
}

variable "arn" {
    type        = string
    default = "arn:aws:iam::471627162277:role/seojin-eks-karpenter"
}

variable "instance_role" {
    type        = string
    default = "arn:aws:iam::471627162277:role/alin-tf-eks-ng-iam-role"
}


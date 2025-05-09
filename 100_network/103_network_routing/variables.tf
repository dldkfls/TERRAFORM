###############################################################################
# Tag
################################################################################
variable "default_tag" {
    type      = string
    default   = "terraform"
}

###############################################################################
# Name
################################################################################
variable "public_rt_name" {
    type      = string
    default   = "alin-test-pub-rt"
}
variable "private_rt_name" {
    type      = string
    default   = "alin-test-pri-rt"
}
variable "ngw_cidr" {
    type      = string
    default   = "0.0.0.0/0"
}
variable "igw_cidr" {
    type      = string
    default   = "0.0.0.0/0"
}

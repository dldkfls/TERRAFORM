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
variable "igw_name" {
    type      = string
    default   = "alin-test-igw"
}
variable "eip_name" {
    type      = string
    default   = "alin-test-eip"
}

variable "ngw_name" {
    type      = string
    default   = "alin-test-ngw"
}
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

################################################################################
# Instance
################################################################################
resource
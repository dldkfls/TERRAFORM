#data "terraform_remote_state" "eks_cluster" {
#  backend = "s3"
#  config = {
#    bucket  = "alin-terraform-state-bucket"
#    key     = "300_eks/304_eks_existing/terraform.tfstate"
#    region  = "ap-northeast-2"
#    profile = "Administrator-471627162277"
#  }
#}

## Karpenter Helm 설치를 위한 Remote Exec
#resource "null_resource" "install_karpenter" {
#  provisioner "remote-exec" {
#    inline = [
#      "helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter \\",
#      "  --version \"${var.karpenter_version}\" \\",
#      "  --namespace \"${var.karpenter_namespace}\" \\",
#      "  --create-namespace \\",
#      "  --set \"settings.clusterName=${data.terraform_remote_state.eks_cluster.outputs.eks_cluster_name}\" \\",
#      "  --set \"settings.interruptionQueue=${data.terraform_remote_state.eks_cluster.outputs.eks_cluster_name}\" \\",
#      "  --set controller.resources.requests.cpu=1 \\",
#      "  --set controller.resources.requests.memory=1Gi \\",
#      "  --set controller.resources.limits.cpu=1 \\",
#      "  --set controller.resources.limits.memory=1Gi \\",
#      "  --wait"
#    ]
#
#    connection {
#      type        = "ssh"
#      user        = "sysadm"
#      password    = "tlstprP1@#"
#      host        = "100.69.9.52"
#      agent       = false
#    }
#  }
#}

resource "null_resource" "nodepool_yaml" {
    connection {
        type        = "ssh"
        user        = "sysadm"
        password    = "tlstprP1@#"
        host        = "100.69.9.52"
        agent       = false
    
    }
    provisioner "file" {
    source      = "nodepool.yaml"
    destination = "./nodepool.yaml"
    }
    provisioner "remote-exec" {
        inline = [
        "kubectl apply -f /home/sysadm/nodepool.yaml"
        ]
    }
}

resource "null_resource" "nodeclass_yaml" {
    connection {
        type        = "ssh"
        user        = "sysadm"
        password    = "tlstprP1@#"
        host        = "100.69.9.52"
        agent       = false
    
    }
    provisioner "file" {
    source      = "nodeclass.yaml"
    destination = "./nodeclass.yaml"
    }
    provisioner "remote-exec" {
        inline = [
        "kubectl apply -f /home/sysadm/nodeclass.yaml"
        ]
    }
}
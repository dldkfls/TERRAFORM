data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket  = "alin-terraform-state-bucket"
    key     = "800_eks_karpenter/801_eks_all/terraform.tfstate"
    region  = "ap-northeast-2"
    profile = "Administrator-471627162277"
  }
}

resource "null_resource" "install_karpenter" {
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://raw.githubusercontent.com/aws/karpenter-provider-aws/v${var.karpenter_version}/website/content/en/preview/getting-started/getting-started-with-karpenter/cloudformation.yaml ${TEMPOUT}" \\,
      "aws cloudformation deploy --stack-name Karpenter-${data.terraform_remote_state.eks_cluster.outputs.eks_cluster_name} --template-file /tmp/karpenter.yaml --capabilities CAPABILITY_NAMED_IAM --parameter-overrides ClusterName=${data.terraform_remote_state.eks_cluster.outputs.eks_cluster_name}" \\,
      "helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter --version \"${var.karpenter_version}\" --namespace \"${var.karpenter_namespace}\" --create-namespace --set \"settings.clusterName=${data.terraform_remote_state.eks_cluster.outputs.eks_cluster_name}\" --set \"settings.interruptionQueue=${data.terraform_remote_state.eks_cluster.outputs.eks_cluster_name}\" --set controller.resources.requests.cpu=1 --set controller.resources.requests.memory=1Gi --set controller.resources.limits.cpu=1 --set controller.resources.limits.memory=1Gi --wait"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = "tlstprP1@#"
    host        = "100.69.9.67"
    agent       = false
  }
}

resource "null_resource" "nodepool_yaml" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = "tlstprP1@#"
    host        = "100.69.9.67"
    agent       = false
  }
  provisioner "file" {
    source      = "nodepool.yaml"
    destination = "/home/ec2-user/nodepool.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "kubectl apply -f /home/ec2-user/nodepool.yaml"
    ]
  }
}

resource "null_resource" "nodeclass_yaml" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = "tlstprP1@#"
    host        = "100.69.9.67"
    agent       = false
  }
  provisioner "file" {
    source      = "nodeclass.yaml"
    destination = "/home/ec2-user/nodeclass.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "kubectl apply -f /home/ec2-user/nodeclass.yaml"
    ]
  }
}

resource "null_resource" "pause_test" {
    connection {
        type        = "ssh"
        user        = "sysadm"
        password    = "tlstprP1@#"
        host        = "100.69.9.52"
        agent       = false
    
    }
    provisioner "file" {
    source      = "pause.yaml"
    destination = "./pause.yaml"
    }
    provisioner "remote-exec" {
        inline = [
        "kubectl apply -f /home/sysadm/pause.yaml"
        ]
    }
}
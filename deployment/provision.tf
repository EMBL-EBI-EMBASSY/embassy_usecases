resource "null_resource" "provision" {
  depends_on = ["openstack_compute_floatingip_associate_v2.connection"]
  provisioner "file" {
     source = "${var.docker_repo}"
     destination = "/tmp/docker.repo"
  }
  provisioner "remote-exec" {
    inline = [
        "sudo mv /tmp/docker.repo /etc/yum.repos.d/docker.repo",
        "sudo yum install epel-release -y",
        "sudo yum group install -y 'Development Tools'",
        "sudo yum install docker-engine python-devel python-pip -y",
        "sudo pip install cwlref-runner cwltool",
        "sudo systemctl start docker",
        "sudo systemctl start docker",
        "sudo usermod -aG docker $(whoami)"
    ]
  }
  connection {
     type = "ssh"
     user = "centos"
     private_key = "${file(var.ssh-key-private)}"
     agent = true
     host = "${var.public_ip}"
  }
}

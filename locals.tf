locals {
  ssh_public_key = file("id_rsa.pub")
  ubuntu_ssh_key = "ubuntu:${local.ssh_public_key}"
}

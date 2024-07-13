# VM kube master node
resource "yandex_compute_instance" "node-master" {
  name                      = "node-master-a"
  hostname                  = "node-master-a"
  zone                      = "ru-central1-a"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet["a"].id
    nat       = true
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.ubuntu_ssh_key
  }
}

output "external_ip_address_master" {
  value = yandex_compute_instance.node-master.network_interface.0.nat_ip_address
}

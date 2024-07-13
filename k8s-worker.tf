## VM Worker Nodes
resource "yandex_compute_instance" "node-worker" {
  for_each = merge([
    for k, v in var.workers :
    {for i in range(v) : "node-worker-${k}-${i + 1}" => k}
  ]...)
  name                      = each.key
  zone                      = "ru-central1-${each.value}"
  hostname                  = each.key
  platform_id               = "standard-v3"
  allow_stopping_for_update = true
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
    }
  }
  scheduling_policy {
    preemptible = true # приостанавливаемая
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet[each.value].id}"
    nat       = false
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.ubuntu_ssh_key
  }
}

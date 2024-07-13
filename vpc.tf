# VPC
resource "yandex_vpc_network" "network-diplom" {
  name      = "network-diplom"
  folder_id = var.YC_FOLDER_ID
}
# Subnets
resource "yandex_vpc_subnet" "subnet" {
  for_each       = tomap(var.subnets)
  name           = "subnet-${each.key}"
  zone           = "ru-central1-${each.key}"
  network_id     = yandex_vpc_network.network-diplom.id
  v4_cidr_blocks = [each.value]
}

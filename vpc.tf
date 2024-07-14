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
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id = var.YC_FOLDER_ID
  name      = "test-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  folder_id  = var.YC_FOLDER_ID
  name       = "test-route-table"
  network_id = yandex_vpc_network.network-diplom.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

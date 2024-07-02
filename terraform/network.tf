resource "yandex_vpc_network" "network-1" {
  name = local.network_name
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = local.subnet_name1
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = local.subnet_name2
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.2.0/24"]
}

#resource "yandex_vpc_subnet" "subnet-3" {
#  name           = local.subnet_name3
#  zone           = "ru-central1-c"
#  network_id     = yandex_vpc_network.network-1.id
#  v4_cidr_blocks = ["192.168.3.0/24"]
#}
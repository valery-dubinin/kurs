# Zabbix сервер

resource "yandex_compute_instance" "zabbix-server" {
  zone        = "ru-central1-a"
  name        = "zabbix-server"
  hostname    = "zabbix-server"
  platform_id = "standard-v2"
  
  resources {
    cores  = 2
    memory = 4
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      size = 10
      image_id = yandex_compute_image.ubuntu20.id
      type = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    security_group_ids = [yandex_vpc_security_group.zabbix-server-sg.id, 
                          yandex_vpc_security_group.ssh-from-basion.id,]
    nat       = true
  }

  metadata = {
    user-data = "${file("./metafiles/meta.yml")}"
    serial-port-enable = 1
  }
}

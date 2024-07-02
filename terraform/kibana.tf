# ElasticSearch сервер

resource "yandex_compute_instance" "kibana" {
  zone        = "ru-central1-a"
  name        = "kibana"
  hostname    = "kibana"
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
    security_group_ids = [yandex_vpc_security_group.kibana-sg.id, 
                          yandex_vpc_security_group.ssh-from-basion.id,
                          yandex_vpc_security_group.zabbix-agent-sg.id]
    ip_address         = "192.168.1.200" 
    nat       = true
  }

  metadata = {
    user-data = "${file("./metafiles/meta.yml")}"
    serial-port-enable = 1
  }
}

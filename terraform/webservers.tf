# Группа веб серверов

resource "yandex_compute_instance_group" "webservers-group" {
  name               = "webservers-group"
#  folder_id          = var.folder_id
  service_account_id = var.yc_service_acc_id
  instance_template {
    platform_id        = "standard-v2"
    service_account_id = var.yc_service_acc_id
    name        = "webserver-{instance.index}"
    hostname    = "webserver-{instance.index}"
    resources {
      core_fraction = 5
      memory        = 2
      cores         = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = yandex_compute_image.ubuntu20.id
        type     = "network-hdd"
        size     = 10
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.network-1.id
      subnet_ids         = [yandex_vpc_subnet.subnet-1.id,yandex_vpc_subnet.subnet-2.id]
      nat                = false
      security_group_ids = [yandex_vpc_security_group.webserver-sg.id, 
                            yandex_vpc_security_group.ssh-from-basion.id,
                            yandex_vpc_security_group.filebeat-sg.id,
                            yandex_vpc_security_group.zabbix-agent-sg.id]
    }

    metadata = {
      user-data = "${file("./metafiles/meta_ig.yml")}"
      serial-port-enable = 1
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  application_load_balancer {
    target_group_name = "alb-tg"
  }
}
# Переменные образов

resource "yandex_compute_image" "ubuntu22" {
  source_family = "ubuntu-2204-lts"
}

resource "yandex_compute_image" "ubuntu20" {
  source_family = "ubuntu-2004-lts"
}

# Добавление прочих переменных

locals {
  sa_name      = "ig-sa"
  network_name = "network1"
  subnet_name1 = "subnet-1"
  subnet_name2 = "subnet-2"
  subnet_name3 = "subnet-3"
}

# Настройка провайдера

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {

  #token     = "{$YC_TOKEN}"
  #cloud_id  = "{$YC_CLOUD_ID}"
  #folder_id = "{$YC_FOLDER_ID}"
  token      = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-b"
}
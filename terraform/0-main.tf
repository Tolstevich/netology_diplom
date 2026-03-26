terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.8.0"
}
provider "yandex" {
    zone                     = var.zone_a
    cloud_id                 = var.cloud_id
    folder_id                = var.folder_id
    service_account_key_file = var.authorized_key
}
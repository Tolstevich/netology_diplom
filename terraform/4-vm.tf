# Общий образ на всех виртуалках
data "yandex_compute_image" "ubuntu_24_04" {
    family = "ubuntu-2404-lts"
}
# Тут я создаю бастион
resource "yandex_compute_instance" "bastion" {
    name         = "bastion"
    hostname     = "bastion"
    platform_id  = "standard-v3"
    zone         = var.zone_a
    
    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_24_04.id
            type     = "network-hdd"
            size     = 20
        }
    }
    network_interface {
        subnet_id           = yandex_vpc_subnet.public_subnet.id
        nat                 = true
        security_group_ids  = [yandex_vpc_security_group.bastion_sg.id]
    }
    metadata = {
        user-data          = file("./cloud-init.yml")
        serial_port_enable = 1
    }
}
# ВМ с nginx-01
resource "yandex_compute_instance" "web_01" {
    name        = "web-01"
    hostname    = "web-01"
    platform_id = "standard-v3"
    zone        = var.zone_a

    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id  = data.yandex_compute_image.ubuntu_24_04.id
            type      = "network-hdd"
            size      = 20
        }
    }   
    network_interface {
        subnet_id           = yandex_vpc_subnet.private_a.id
        nat                 = false
        security_group_ids  = [yandex_vpc_security_group.web_sg.id]
        }
    metadata = {
        user-data          = file("./cloud-init.yml")
        serial_port_enable = 1
    }
}
#ВМ с nginx-02
resource "yandex_compute_instance" "web_02" {
    name        = "web-02"
    hostname    = "web-02"
    platform_id = "standard-v3"
    zone        = var.zone_b

    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_24_04.id
            type     = "network-hdd"
            size     = 20
        }
    }    
    network_interface {
        subnet_id           = yandex_vpc_subnet.private_b.id
        nat                 = false
        security_group_ids  = [yandex_vpc_security_group.web_sg.id]
       }
    metadata = {
        user-data          = file("./cloud-init.yml")
        serial_port_enable = 1
    }
}
#Заббикс сервер
resource "yandex_compute_instance" "zabbix" {
    name        = "zabbix"
    hostname    = "zabbix"
    platform_id = "standard-v3"
    zone        = var.zone_a

    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_24_04.id
            type     = "network-hdd"
            size     = 20
        }
    }    
    network_interface {
        subnet_id           = yandex_vpc_subnet.public_subnet.id
        nat                 = true
        security_group_ids  = [yandex_vpc_security_group.zabbix_sg.id]
       }
    metadata = {
        user-data          = file("./cloud-init.yml")
        serial_port_enable = 1
    }
}
# Эластик
resource "yandex_compute_instance" "elasticsearch" {
    name        = "elasticsearch"
    hostname    = "elasticsearch"
    platform_id = "standard-v3"
    zone        = var.zone_a

    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_24_04.id
            type     = "network-hdd"
            size     = 20
        }
    }    
    network_interface {
        subnet_id           = yandex_vpc_subnet.private_a.id
        nat                 = false
        security_group_ids  = [yandex_vpc_security_group.elasticsearch_sg.id]
       }
    metadata = {
        user-data          = file("./cloud-init.yml")
        serial_port_enable = 1
    }
}
# Кибана
resource "yandex_compute_instance" "kibana" {
    name        = "kibana"
    hostname    = "kibana"
    platform_id = "standard-v3"
    zone        = var.zone_a

    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_24_04.id
            type     = "network-hdd"
            size     = 20
        }
    }    
    network_interface {
        subnet_id           = yandex_vpc_subnet.public_subnet.id
        nat                 = true
        security_group_ids = [yandex_vpc_security_group.kibana_sg.id]
       }
    metadata = {
        user-data          = file("./cloud-init.yml")
        serial_port_enable = 1
    }
}
#Создаю инвентори файл для ансибл. Задаю группы и переменные для выполнения ансиблом
resource "local_file" "inventory" {
  content  = <<-XYZ
  [bastion]
  ${yandex_compute_instance.bastion.hostname}.${yandex_compute_instance.bastion.zone}.internal ansible_host=${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}

  [webservers]
  ${yandex_compute_instance.web_01.hostname}.${yandex_compute_instance.web_01.zone}.internal ansible_host=${yandex_compute_instance.web_01.network_interface.0.ip_address}
  ${yandex_compute_instance.web_02.hostname}.${yandex_compute_instance.web_02.zone}.internal ansible_host=${yandex_compute_instance.web_02.network_interface.0.ip_address}

  [zabbix]
  ${yandex_compute_instance.zabbix.hostname}.${yandex_compute_instance.zabbix.zone}.internal ansible_host=${yandex_compute_instance.zabbix.network_interface.0.ip_address}

  [elasticsearch]
  ${yandex_compute_instance.elasticsearch.hostname}.${yandex_compute_instance.elasticsearch.zone}.internal ansible_host=${yandex_compute_instance.elasticsearch.network_interface.0.ip_address}

  [kibana]
  ${yandex_compute_instance.kibana.hostname}.${yandex_compute_instance.kibana.zone}.internal ansible_host=${yandex_compute_instance.kibana.network_interface.0.ip_address}


  [all:vars]
  ansible_user=ansible
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q ansible@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

  XYZ
  filename = "../ansible/hosts.ini"
}
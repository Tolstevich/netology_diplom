resource "yandex_vpc_security_group" "bastion_sg" {
    name       = "bastion_sg"
    network_id = yandex_vpc_network.vpc_network.id

    ingress {
        protocol       = "TCP"
        v4_cidr_blocks = ["0.0.0.0/0"]
        description    = "ssh"
        port           = 22
    }
    ingress {
        protocol        = "TCP"
        description     = "Для заббикса"
        port            = 10050
        v4_cidr_blocks  = ["192.168.1.7/32"] 
    }
    egress {
        protocol       = "ANY"
        v4_cidr_blocks = ["0.0.0.0/0"]
        description    = "Permit any"
        from_port      = 0
        to_port        = 65535
    }
}
resource "yandex_vpc_security_group" "load_balancer_sg" {
    name               = "load_balancer"
    network_id         = yandex_vpc_network.vpc_network.id

    ingress {
        protocol         = "TCP"
        description      = "HTTP"
        v4_cidr_blocks   = ["0.0.0.0/0"]
        port             = 80
    }
    ingress {
        protocol          = "TCP"
        description       = "healthcheck"
        port              = 30080
        predefined_target = "loadbalancer_healthchecks"
    }
    egress {
        protocol         = "ANY"
        v4_cidr_blocks   = ["0.0.0.0/0"]
        from_port        = 0
        to_port          = 65535
    }

}
resource "yandex_vpc_security_group" "web_sg" {
    name       = "web_sg"
    network_id = yandex_vpc_network.vpc_network.id

    ingress {
        protocol           = "TCP"
        description        = "Для балансировщика"
        port               = 80
        security_group_id  = yandex_vpc_security_group.load_balancer_sg.id
    }
    ingress {
        protocol           = "TCP"
        description        = "Для бастиона"
        port               = 22
        security_group_id  = yandex_vpc_security_group.bastion_sg.id
    }
    ingress {
        protocol           = "TCP"
        description        = "Для заббикса"
        port               = 10050
        security_group_id  = yandex_vpc_security_group.zabbix_sg.id
    }
    egress {
        protocol       = "ANY"
        v4_cidr_blocks = ["0.0.0.0/0"]
        from_port      = 0
        to_port        = 65535
    }
}
resource "yandex_vpc_security_group" "zabbix_sg" {
    name               = "zabbix_sg"
    network_id = yandex_vpc_network.vpc_network.id

    ingress {
        protocol          = "TCP"
        description       = "ssh"
        port              = 22
        security_group_id = yandex_vpc_security_group.bastion_sg.id
    }
    ingress {
        protocol          = "TCP"
        description       = "Для веб-интерфейса"
        port              = 80
        v4_cidr_blocks    = ["0.0.0.0/0"]
    }
    egress {
        protocol          = "ANY"
        v4_cidr_blocks = ["0.0.0.0/0"]
        from_port         = 0
        to_port           = 65535
    }
}
resource "yandex_vpc_security_group" "kibana_sg" {
    name       = "kibana_sg"
    network_id = yandex_vpc_network.vpc_network.id

    ingress {
        protocol          = "TCP"
        description       = "Веб-интерфейс"
        port              = 5601
        v4_cidr_blocks    = ["0.0.0.0/0"]
    }
    ingress {
        protocol          = "TCP"
        description       = "Ссш для бастиона"
        port              = 22
        security_group_id = yandex_vpc_security_group.bastion_sg.id
    }
    ingress {
        protocol           = "TCP"
        description        = "Для заббикса"
        port               = 10050
        security_group_id  = yandex_vpc_security_group.zabbix_sg.id
    }
    egress {
        protocol          = "ANY"
        v4_cidr_blocks    = ["0.0.0.0/0"]
        from_port         = 0
        to_port           = 65535
    }
}
resource "yandex_vpc_security_group" "elasticsearch_sg" {
    name       = "elasticsearch"
    network_id = yandex_vpc_network.vpc_network.id

    ingress {
        protocol          = "TCP"
        description       = "Для бастиона"
        port              = 22
        security_group_id = yandex_vpc_security_group.bastion_sg.id 
    }
    ingress {
        protocol          = "TCP"
        description       = "Для web"
        port              = 9200
        security_group_id = yandex_vpc_security_group.web_sg.id
    }
    ingress {
        protocol          = "TCP"
        description       = "Для kibana"
        port              = 9200
        security_group_id = yandex_vpc_security_group.kibana_sg.id 
    }
    ingress {
        protocol          = "TCP"
        description       = "filebeat для web"
        port              = 5044
        security_group_id = yandex_vpc_security_group.web_sg.id 
    }
    ingress {
        protocol           = "TCP"
        description        = "Для заббикса"
        port               = 10050
        security_group_id  = yandex_vpc_security_group.zabbix_sg.id
    }
    egress {
        protocol          = "ANY"
        v4_cidr_blocks    = ["0.0.0.0/0"]
        from_port         = 0
        to_port           = 65535
    }
}
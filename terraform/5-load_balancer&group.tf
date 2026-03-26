# Делаю таргет группу
resource "yandex_alb_target_group" "target-group-web" {
    name = "target-group-web"

    target {
        subnet_id  = yandex_vpc_subnet.private_a.id
        ip_address = yandex_compute_instance.web_01.network_interface.0.ip_address
    }
        target {
        subnet_id  = yandex_vpc_subnet.private_b.id
        ip_address = yandex_compute_instance.web_02.network_interface.0.ip_address
    }
}
# Делаю бэкэнд группу
resource "yandex_alb_backend_group" "backend-group" {
    name = "backend-group"

    http_backend {
        name             = "web-backend"
        port             = 80
        target_group_ids = [yandex_alb_target_group.target-group-web.id]

        healthcheck {
            timeout          = "2s"
            interval         = "5s"
            http_healthcheck {
                path = "/"
            }
        }
    }
}
resource "yandex_alb_http_router" "router" {
    name = "router"
}
resource "yandex_alb_virtual_host" "virtual-host" {
    name           = "virtual-host"
    http_router_id = yandex_alb_http_router.router.id

    route {
        name     = "route-root"
        http_route {
            http_route_action {
                backend_group_id = yandex_alb_backend_group.backend-group.id
                timeout          = "3s"
            }
        }
    }
}
resource "yandex_alb_load_balancer" "load-balancer" {
    name       = "load-balancer"
    network_id = yandex_vpc_network.vpc_network.id

    allocation_policy {
        location {
            zone_id   = var.zone_a
            subnet_id = yandex_vpc_subnet.public_subnet.id 
        }
    }
    listener {
        name = "listener"
        endpoint {
            address {
                external_ipv4_address {
                }
            }
            ports = [80]
        }
        http {
            handler {
                http_router_id = yandex_alb_http_router.router.id
            }
        }
    }
    security_group_ids = [yandex_vpc_security_group.load_balancer_sg.id]
}


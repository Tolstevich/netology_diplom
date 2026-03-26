# Сеть
resource "yandex_vpc_network" "vpc_network"{
    name        = var.network
    description = "diplom_network" 
}
# Подсеть для внешнего мира
resource "yandex_vpc_subnet" "public_subnet" {
    name           = "public_subnet"
    zone           = var.zone_a
    network_id     = yandex_vpc_network.vpc_network.id
    v4_cidr_blocks = var.public_subnet
    route_table_id = yandex_vpc_route_table.rt.id
}
# Подсеть для внутрянки-1
resource "yandex_vpc_subnet" "private_a" {
    name           = "private_subnet-1"
    zone           = var.zone_a
    network_id     = yandex_vpc_network.vpc_network.id
    v4_cidr_blocks = var.private_subnet_1
    route_table_id = yandex_vpc_route_table.rt.id 
}
# Подсеть для внутрянки-2
resource "yandex_vpc_subnet" "private_b" {
    name           = "private_subnet_2"
    zone           = var.zone_b
    network_id     = yandex_vpc_network.vpc_network.id
    v4_cidr_blocks = var.private_subnet_2
    route_table_id = yandex_vpc_route_table.rt.id 
}
# Нат
resource "yandex_vpc_gateway" "nat" {
    name           = "gateway"
    shared_egress_gateway {}
}
# Таблица маршрутизации
resource "yandex_vpc_route_table" "rt" {
    name           = "route_table"
    network_id     = yandex_vpc_network.vpc_network.id

    static_route {
        destination_prefix = "0.0.0.0/0"
        gateway_id         = yandex_vpc_gateway.nat.id
    }
}

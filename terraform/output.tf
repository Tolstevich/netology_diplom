# Все ip с публичными адресами
output "bastion_public_ip" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  description = "Public IP of bastion host for SSH access"
}

output "zabbix_public_ip" {
  value = yandex_compute_instance.zabbix.network_interface.0.nat_ip_address
  description = "Public IP of Zabbix web interface"
}

output "kibana_public_ip" {
  value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
  description = "Public IP of Kibana"
}

output "load_balancer_public_ip" {
  value = yandex_alb_load_balancer.load-balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
  description = "Public IP of load balancer (website)"
}

# Все внутренние адреса
output "web_01_private_ip" {
  value = yandex_compute_instance.web_01.network_interface.0.ip_address
  description = "Private IP of web-01"
}

output "web_02_private_ip" {
  value = yandex_compute_instance.web_02.network_interface.0.ip_address
  description = "Private IP of web-02"
}

output "elasticsearch_private_ip" {
  value = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
  description = "Private IP of Elasticsearch"
}

output "zabbix_private_ip" {
  value = yandex_compute_instance.zabbix.network_interface.0.ip_address
  description = "Private IP of Zabbix server"
}

output "kibana_private_ip" {
  value = yandex_compute_instance.kibana.network_interface.0.ip_address
  description = "Private IP of Kibana"
}
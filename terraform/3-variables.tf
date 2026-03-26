variable "network" {
    type    = string
    default = "network_diplom" 
}

variable "cloud_id" {
    type    = string
    default = "b1gj5tmhc48vdc0d8hsp" 
}

variable "folder_id" {
    type    = string
    default = "b1g1j9ddbb0pvnfkf25u" 
}
variable "zone_a" {
    type    = string
    default = "ru-central1-a"
}

variable "zone_b" {
    type    = string
    default = "ru-central1-b"
}

variable "public_subnet" {
    type    = list(string) 
    default = ["192.168.1.0/24"]
}

variable "private_subnet_1" {
    type    = list(string) 
    default = ["192.168.2.0/24"]
}
variable "private_subnet_2" {
    type    = list(string) 
    default = ["192.168.3.0/24"]
}
variable "authorized_key" {
    type    = string
    default = "./authorized_key.json" 
}
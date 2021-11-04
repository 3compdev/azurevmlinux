variable "node_location" {
  type = string
}
variable "node_location-uk" {
  type = string
}
variable "node_location-ny" {
  type = string
}
variable "node_location-sg" {
  type = string
}
variable "resource_prefix" {
  type = string
}
variable "node_address_space" {
  default = ["10.0.0.0/16"]
}
#variable for network range
variable "node_address_prefix" {
  default = "10.0.1.0/24"
}
variable "node_address_space-uk" {
  default = ["10.0.0.0/16"]
}
#variable for network range
variable "node_address_prefix-uk" {
  default = "10.0.1.0/24"
}
variable "node_address_space-ny" {
  default = ["10.10.0.0/16"]
}
#variable for network range
variable "node_address_prefix-ny" {
  default = "10.10.1.0/24"
}
variable "node_address_space-sg" {
  default = ["10.20.0.0/16"]
}
#variable for network range
variable "node_address_prefix-sg" {
  default = "10.20.1.0/24"
}

#variable for Environment
variable "Environment" {
  type = string
}
variable "node_count" {
  type = number
}
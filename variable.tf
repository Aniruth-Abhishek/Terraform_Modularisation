variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "region" {
  description = "The region for the subnetworks"
  type        = string
}

variable "subnetworks" {
  description = "A list of subnetwork configurations"
  type = list(object({
    name          = string
    ip_cidr_range = string
  }))
}

variable "firewall_name" {
  description = "The name of the firewall rule"
  type        = string
}

variable "allowed_ports" {
  description = "List of ports the firewall rule will allow"
  type        = list(string)
}

variable "source_ranges" {
  description = "CIDR blocks that are allowed to access the network"
  type        = list(string)
}

variable "vm_instances" {
  description = "A list of VM instance configurations"
  type = list(object({
    name             = string
    machine_type     = string
    zone             = string
    subnetwork_name  = string
    boot_disk_image  = string
  }))
}

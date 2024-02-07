vpc_name       = "stld-monitoring"
region         = "asia-south1"
subnetworks    = [
  { name = "asia-south1a-public", ip_cidr_range = "10.10.1.0/24" },
  { name = "asia-south1b-public", ip_cidr_range = "10.10.2.0/24" }
]
firewall_name  = "nms-firewall"
allowed_ports  = ["22", "80", "443"]
source_ranges  = ["0.0.0.0/0"]
vm_instances   = [
  { name = "vm1-nagios", machine_type = "e2-small", zone = "asia-south1-a", subnetwork_name = "asia-south1a-public", boot_disk_image = "rocky-linux-cloud/rocky-linux-8" },
  { name = "vm2-zabbix", machine_type = "e2-small", zone = "asia-south1-b", subnetwork_name = "asia-south1b-public", boot_disk_image = "rocky-linux-cloud/rocky-linux-8" }
]

resource "google_compute_network" "stld_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each      = { for sn in var.subnetworks : sn.name => sn }
  name          = each.value.name
  region        = var.region
  network       = google_compute_network.stld_vpc.name
  ip_cidr_range = each.value.ip_cidr_range
}

resource "google_compute_firewall" "allow_web_ssh_traffic" {
  name    = var.firewall_name
  network = google_compute_network.stld_vpc.name

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports
  }

  source_ranges = var.source_ranges
}

resource "google_compute_instance" "vm_instance" {
  for_each     = { for vm in var.vm_instances : vm.name => vm }
  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = each.value.boot_disk_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnetwork[each.value.subnetwork_name].name
    access_config {
      // Ephemeral IP configuration (if any specific settings needed, they can be added here)
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

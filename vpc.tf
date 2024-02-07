resource "google_compute_network" "stldm_vpc" { #### its an argument name ( reference)
  name                    = "stld-monitoring"  ### it will be dispalyed in console
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "asia_south1a_public" {
  name          = "asia-south1a-public"
  region        = "asia-south1"
  network       = google_compute_network.stldm_vpc.name
  ip_cidr_range = "10.10.1.0/24"
}

resource "google_compute_subnetwork" "asia_south1b_public" {
  name          = "asia-south1b-public"
  region        = "asia-south1"
  network       = google_compute_network.stldm_vpc.name
  ip_cidr_range = "10.10.2.0/24"
}  ### after changing anything press ctrl+s 

# Firewall rule allowing TCP traffic on ports 22 (SSH), 80 (HTTP), and 443 (HTTPS)
resource "google_compute_firewall" "allow_web_ssh_traffic" {
  name    = "nms-firewall"
  network = google_compute_network.stldm_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  # Source ranges for the firewall rule. Using 0.0.0.0/0 allows traffic from any source.
  # Adjust as necessary to restrict access.
  source_ranges = ["0.0.0.0/0"]
}


# VM instance in the asia-south1a-public subnet
resource "google_compute_instance" "vm_instance_asia_south1a" {
  name         = "vm1-nagios"
  machine_type = "e2-small"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.asia_south1b_public.name
    access_config {
      // Ephemeral IP
    }
  }
}

# VM instance in the asia-south1b-public subnet
resource "google_compute_instance" "vm_instance_asia_south1b" {
  name         = "vm2-zabbix"
  machine_type = "e2-small"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.asia_south1a_public.name
    access_config {
      // Ephemeral IP
    }
  }
}
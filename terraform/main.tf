provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("${path.module}/credentials.json")
}


resource "google_compute_network" "vpc_network" {
  name = "${var.instance_name}-${substr(var.commit_id,0,8)}-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow_ports" {
  name    = "allow-ssh-grafana-prometheus-${substr(var.commit_id,0,8)}"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3000", "9090", "9100"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "${var.instance_name}-${substr(var.commit_id,0,8)}"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size = 20
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
      # Reservar IP externo
    }
  }

  metadata = {
    ssh-keys = "debian:${var.ssh_public_key}"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
  EOT

  tags = ["grafana", "prometheus"]
}

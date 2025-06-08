provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("${path.module}/credentials.json")
}


locals {
  cid = var.commit_id != "" ? substr(var.commit_id, 0, 8) : "manual"
}

resource "google_compute_firewall" "allow_ports" {
  name    = "allow-ssh-grafana-prometheus-${local.cid}"
  network = var.network_name
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3000", "9090", "9100"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "${var.instance_name}-${local.cid}"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }

  network_interface {
    network = var.network_name

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

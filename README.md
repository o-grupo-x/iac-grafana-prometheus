# Grafana and Prometheus Infrastructure

This repository contains Terraform configuration to provision a Debian VM on Google Cloud and an Ansible playbook to deploy Grafana, Prometheus, Node Exporter and an nginx reverse proxy using Docker.

## Prerequisites

* Terraform 1.8+
* Ansible
* Access to a Google Cloud project with Compute Engine enabled

## Usage

1. Encode a Google Cloud service account key as base64 and store it in the
   `GCP_CREDENTIALS_B64` secret. The workflow decodes this value into
   `terraform/credentials.json`. When running locally, create the file manually.
2. Run `terraform init` and `terraform apply` in the `terraform` directory.
3. Note the VM's public IP from Terraform outputs.
4. Run `./update_inventory.sh` to populate `ansible/hosts.ini` with the VM IP.
5. Save your private SSH key **base64-encoded** in the `ANSIBLE_SSH_PRIVATE_KEY_B64`
   secret. The workflow will decode this value into `ansible/ssh_key`. Ensure the
   secret is not empty and contains a valid private key before running the
   playbook:

```bash
ansible-playbook -i ansible/hosts.ini ansible/playbook.yaml
```

The playbook installs Docker on the VM and starts Grafana, Prometheus, Node Exporter and nginx containers.


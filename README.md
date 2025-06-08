# Grafana and Prometheus Infrastructure

This repository contains Terraform configuration to provision a Debian VM on Google Cloud and an Ansible playbook to deploy Grafana, Prometheus, Node Exporter and an nginx reverse proxy using Docker.

## Prerequisites

* Terraform 1.8+
* Ansible
* Access to a Google Cloud project with Compute Engine enabled

## Usage

1. Create `terraform/credentials.json` with a service account key that has appropriate permissions.
2. Run `terraform init` and `terraform apply` in the `terraform` directory.
3. Note the VM's public IP from Terraform outputs.
4. Run `./update_inventory.sh` to populate `ansible/hosts.ini` with the VM IP.
5. Save your private SSH key base64 encoded in the `ANSIBLE_SSH_PRIVATE_KEY_B64`
   secret and run the playbook (the inventory references `ansible/ssh_key`):

```bash
ansible-playbook -i ansible/hosts.ini ansible/playbook.yaml
```

The playbook installs Docker on the VM and starts Grafana, Prometheus, Node Exporter and nginx containers.


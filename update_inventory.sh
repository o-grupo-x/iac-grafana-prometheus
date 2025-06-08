#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
VM_IP=$(terraform -chdir="$REPO_ROOT/terraform" output -raw instance_ip)

cat > "$REPO_ROOT/ansible/hosts.ini" <<HOSTS
[vm]
$VM_IP ansible_user=debian ansible_ssh_private_key_file=ssh_key
HOSTS

echo "Updated ansible/hosts.ini with IP $VM_IP"

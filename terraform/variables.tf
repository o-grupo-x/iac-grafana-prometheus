variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "app-chamada-5706"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
  default     = "instance-grafana-prometheus"
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
  default     = ""
}

variable "commit_id" {
  description = "Commit ID used to uniquely name resources"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "VPC network to deploy resources in"
  type        = string
  default     = "default"
}
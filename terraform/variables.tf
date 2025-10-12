# variables.tf

# --- Proxmox Provider Configuration ---
variable "proxmox_api_url" {
  type        = string
  description = "URL da API do Proxmox (ex: https://pve.example.com:8006/api2/json)"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "ID do token da API do Proxmox (ex: root@pam!terraform)"
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "Segredo do token da API do Proxmox"
  sensitive   = true
}

variable "target_node" {
  type        = string
  description = "O nó do Proxmox onde as VMs serão criadas (ex: pve)"
  default     = "host01"
}

# --- VM Template Configuration ---
variable "template_name" {
  type        = string
  description = "Nome do template Cloud-Init a ser clonado"
  default     = "ubuntu-server" # Altere para o nome do seu template!
}

variable "ssh_public_key" {
  type        = string
  description = "Chave pública SSH para acesso às VMs."
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEZw1ZhihF3Qf4M8NWNy5VjcMb2SozL4aZ2OC+vL/fyllDqEKDMrs1GHxqKeH415NwCFImSvdbsyjpp5JnEZvGl1r8sxd6UWWGc9mTX5zoR1iDX4XTENi23Oa0Px3sCjO1Bdx/FXWI9kzdJ1pFTtiAen91Sb1QJOIv2D1LnLXBAFFNQdRNfiI4vg+JhhbPLy9JpgtOtmjNXR6fUuovGdt1bd8sNeolOFfmJ7nYZyvMkH4O+Ihfa6OHcdCtZ3tZPJsG2AjYm/rsvfLnPb8hvA3+ShEjif5IDt6qSggF+ApKxAuB5QlWH8JZULwxB53Onxj+4vQE+j/FrSA2gDS6Gu4sXoZF2VfG3QWSIxRRwrHjRuQ1MvfKrkHmjkfXLLdEzU3yNdPR9LvRLMkc8uV+b4X3ZpXyvBtrZX0dbxgQLLQGkOr/HiRuvzigtdv5pWN/XCffMkuNltYw89GL8lVS4Nkj+mp3Ff12XmF+ftfjWJe4bqYFN1arcGu41E3i+TZRDaTEhBuXmDBnRqmGfago0c0JZUI3L6gx5sm2JSLsIloRUfZd818KUin+V1XtN5bSaFiEVWSfKN2NggfKbSSuA4qP0IlT/w9u6qYLKU4k9GfN3nHkhmMWnrtMmlq8/vaqYrRn+e8DdIg+BGWsLepChG1kEnsPLl6DQlVc2dpS+QccDw== itn@zer0kau"
}

# --- Cluster Configuration ---
variable "k8s_count" {
  description = "Quantidade de VMs para o cluster K8s multi-função (masters+workers+serviços)"
  default     = 3
}
variable "k8s_cores" {
  description = "CPUs por VM K8s minimalista"
  default     = 1
}
variable "k8s_memory" {
  description = "RAM por VM K8s minimalista (MB)"
  default     = 1536
}
variable "k8s_disk" {
  description = "Disco por VM K8s minimalista"
  default     = "10G"
}

# --- Network Configuration ---
variable "network_bridge" {
  default = "vmbr0"
}
variable "network_gateway" {
  default = "192.168.1.1" # Altere para o seu gateway
}
variable "network_base_ip" {
  default = "192.168.1.200" # IP inicial para as VMs
}
variable "network_cidr" {
  default = "16" # /16
}
variable "nameserver" {
  default = "1.1.1.1"
}
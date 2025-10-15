# variables.tf

# --- Proxmox Provider Configuration ---
variable "proxmox_api_url" {
  type        = string
  description = "URL da API do Proxmox (/api2/json)"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "ID do token da API do Proxmox"
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "Segredo do token da API do Proxmox"
  sensitive   = true
}

variable "target_node" {
  type        = string
  description = "O nó do Proxmox onde as VMs serão criadas"
}

# --- VM Template Configuration ---
variable "template_name" {
  type        = string
  description = "Nome do template Cloud-Init a ser clonado"
  default     = "ubuntu-server" # nome do template!
}

variable "ssh_public_key" {
  type        = string
  description = "Chave pública SSH para acesso às VMs."
}

# --- Cluster Configuration ---
variable "k8s_count" {
  description = "Quantidade de VMs para o cluster K8s multi-função (masters+workers+serviços)"
  default     = 3
}
variable "k8s_cores" {
  description = "CPUs por VM K8s minimalista"
  default     = 2
}
variable "k8s_memory" {
  description = "RAM por VM K8s minimalista (MB)"
  default     = 8192
}
variable "k8s_disk" {
  description = "Disco por VM K8s minimalista (GB)"
  default     = "50G"
}

# --- Network Configuration ---
variable "network_bridge" {
  default = "vmbr0"
}
variable "nameserver" {
  default = "1.1.1.1"
}
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
  default     = "jcz00-vm1"
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
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDk6SpyFkotVzuMEO2gkUYVIAYoeocxFeNrZI0y1bigrPSioPgUSgVvIDijCc8RVDn+Yme9xh4kQmzmvgNJh786mLtW074CfsU6h9Ip7A23N6wJUdX6W94wfu1o4USpue9axlCldRo50dcsHdwtzjhM6iOPG6Gx/U87TlTd83Z5BHJgHAs20cmc7N4cKnbcS4Pn6LBPoLN58rY4Gko2ld6CVV/jFA6OxqcPJK/WSz7kpqwv0Sh6USEFTolW115rEgItY3uPxxnI2y0Tea04Jr/4iixb3KG69CEC0Xva2pJzUeO5e1uFOILpWnu9VdoewZhBHYlHveO+Bii0Vajb60nyu2TdhBL943gw6CwyEZsoum79pQmvV0rg1YSm5wkD37N+kcLpyPHjsLugkpgcCiFn3iWZ1q0aEZ48FOCLT9pHqyG7TepVrrZ8gDQtZOehk74O6XqBhJkpqDw0iijEpjSO3Wsq8sgiwNkKp5UgJ9DQfBXWAgEWotAdcJsDPYWNaeMjELz3ARVOOfUxH43ZvzLlER4e+/K4REc6LNGNfAFXzcb3dWv4iZZyzIjylFea6sU+lz8CQDVVtjKu3y+1tkFF5vXtwwXInRc2AFY9D08ukrj6hQxH+TfbG7DzB6RQ6rRRAZHoO2UpzXI6JPKlp4fGfeq7pHQjViGiSplCXECpWw== nti@A8-NOTE-014"
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
variable "nameserver" {
  default = "1.1.1.1"
}
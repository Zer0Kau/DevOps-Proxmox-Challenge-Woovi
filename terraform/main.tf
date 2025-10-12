# main.tf

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc04" # Versão compatível com a documentação
    }
  }
}

provider "proxmox" {
  pm_api_url                 = var.proxmox_api_url
  pm_api_token_id            = var.proxmox_api_token_id
  pm_api_token_secret        = var.proxmox_api_token_secret
  pm_tls_insecure            = true
  pm_log_enable              = false
}

# --- Criação dos Nós Master ---

# Ultra minimalista: 3 VMs pequenas para todo o cluster (masters, workers e serviços)
resource "proxmox_vm_qemu" "k8s" {
  count       = var.k8s_count
  name        = "k8s-${count.index + 1}"
  target_node = var.target_node
  clone       = var.template_name

  cpu {
    cores   = var.k8s_cores
    sockets = 1
  }
  memory   = var.k8s_memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  disk {
    type    = "disk"
    storage = "local-lvm"
    size    = var.k8s_disk
    slot    = "virtio0"
  }
  network {
    model  = "virtio"
    bridge = var.network_bridge
    id     = 0
  }
  ipconfig0 = "ip=dhcp"
  nameserver = var.nameserver
  ciuser     = "ubuntu"
  sshkeys    = var.ssh_public_key
}
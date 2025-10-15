# Variáveis de autenticação para acessar a API do Proxmox
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "target_node" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

# Nome do storage pool no Proxmox onde os discos das VMs serão criados
locals {
  disk_storage = "local-lvm"
}


source "proxmox-iso" "ubuntu-server" {
  # Configurações de conexão com o Proxmox
  proxmox_url = var.proxmox_api_url
  username    = var.proxmox_api_token_id
  token       = var.proxmox_api_token_secret
  # Ignora verificação TLS (útil para certificados autoassinados)
  insecure_skip_tls_verify = true

  # Informações gerais da VM
  node                 = var.target_node        # Nome do nó Proxmox
  vm_id                = "900"           # ID da VM
  vm_name              = "ubuntu-server" # Nome da VM
  template_description = "Ubuntu Server para laboratório"

  # ISO de instalação do Ubuntu Server
  boot_iso {
    type     = "scsi"
    iso_file = "local:iso/ubuntu-24.04.2-live-server-amd64.iso"
    unmount  = true
  }

  # Ativa o agente QEMU para integração
  qemu_agent = true

  # Controladora e disco principal da VM
  scsi_controller = "virtio-scsi-pci"
  disks {
    disk_size    = "8G"               # Disco pequeno para economizar espaço
    format       = "raw"              # Formato raw para compatibilidade
    storage_pool = local.disk_storage # Pool de armazenamento definido acima
    type         = "virtio"           # Controladora Virtio para melhor desempenho
    cache_mode   = "writeback"        # Cache writeback acelera operações de disco
  }

  # Recursos de CPU e memória
  cores  = "2"    # 2 vCPUs
  memory = "8192"  # 8GB RAM

  # Configuração de rede
  network_adapters {
    model    = "virtio" # Placa de rede Virtio
    bridge   = "vmbr0"  # Bridge padrão do Proxmox
    firewall = "false"  # Firewall desativado para laboratório
  }

  # Ativa integração cloud-init
  cloud_init              = true
  cloud_init_storage_pool = local.disk_storage

  # Comandos de boot automatizado para instalação desatendida
  boot      = "c"
  boot_wait = "5s"
  boot_command = [
    # Aguarda o menu do GRUB e entra no modo de edição
    "<wait2s>e<wait>",
    # Navega até a linha do kernel
    "<down><down><down><end><wait>",
    # Adiciona parâmetros de autoinstalação
    " autoinstall ds='nocloud;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' cloud-config-url=/dev/null<wait>",
    # Inicia a instalação
    "<F10><wait>"
  ]
  # boot_key_interval pode ser ajustado para depuração se necessário
  # boot_key_interval = "500ms"

  # Diretório HTTP para arquivos cloud-init (user-data/meta-data)
  http_directory = "http"
  # Exemplo de configuração de porta/IP (opcional)
  # http_bind_address = "0.0.0.0"
  # http_port_min     = 8802
  # http_port_max     = 8802

  # Usuário e senha para acesso inicial via SSH
  ssh_username = "ubuntu"
  ssh_private_key_file = "~/.ssh/id_rsa"
  # Ou use chave SSH:
  # ssh_private_key_file = "~/.ssh/id_rsa"

  # Timeout maior para instalações demoradas
  ssh_timeout = "40m"
}


# Build: define como a VM será criada e provisionada
build {
  name    = "ubuntu-server"
  sources = ["source.proxmox-iso.ubuntu-server"]

  # Aguarda o cloud-init finalizar e faz limpeza de arquivos sensíveis
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
  }

  # Copia arquivo de configuração cloud-init customizado para dentro da VM
  provisioner "file" {
    source      = "files/cloud-init-proxmox.cfg"
    destination = "/tmp/cloud-init-proxmox.cfg"
  }

  # Move o arquivo customizado para o local correto do cloud-init
  provisioner "shell" {
    inline = ["sudo cp /tmp/cloud-init-proxmox.cfg /etc/cloud/cloud.cfg.d/cloud-init-proxmox.cfg"]
  }

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init to finish...'",
      "cloud-init status --wait",
      "echo 'Cloud-init finished. Installing qemu-guest-agent...'",
      "sudo apt-get update",
      "sudo apt-get install -y qemu-guest-agent",
      "echo 'Configuring qemu-guest-agent to restart on failure...'",
      "sudo mkdir -p /etc/systemd/system/qemu-guest-agent.service.d",
      "echo -e '[Service]\nRestart=always\nRestartSec=5' | sudo tee /etc/systemd/system/qemu-guest-agent.service.d/restart.conf",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart qemu-guest-agent"
    ]
  }
}
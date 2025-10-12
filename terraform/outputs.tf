# outputs.tf

output "k8s_ips" {
  description = "Endereços IP das VMs do cluster K8s minimalista"
  value       = [for vm in proxmox_vm_qemu.k8s : vm.default_ipv4_address]
}
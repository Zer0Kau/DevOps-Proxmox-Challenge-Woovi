# terraform/inventory.tpl

[k8s_cluster]
%{ for vm in k8s_nodes ~}
${vm.name} ansible_host=${vm.default_ipv4_address}
%{ endfor ~}

[k8s_cluster:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
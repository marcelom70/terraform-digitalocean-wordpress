output "stack_wp_lb_ip" {
    value = module.wp_stack.wp_lb_ip
    description = "IP do load balancer"
}

output "stack_wp_vm_ips" {
    value = module.wp_stack.wp_vm_ips
    description = "IPs das máquinas do wordpress"
}

output "stack_nfs_vm_ip" {
    value = module.wp_stack.nfs_vm_ip
    description = "IP da máquina NFS"
}

output "stack_wp_db_user" {
    value = module.wp_stack.wp_db_user
    description = "Nome do usuário no banco"
}


output "wp_lb_ip" {
    value = digitalocean_loadbalancer.wp_lb.ip  
    description = "IP do load balancer"
}

output "wp_vm_ips" {
    value = digitalocean_droplet.vm_wp[*].ipv4_address
    description = "IPs das máquinas do wordpress"
}

output "nfs_vm_ip" {
    value = digitalocean_droplet.vm_nfs.ipv4_address
    description = "IP da máquina NFS"
}

output "wp_db_user" {
    value = digitalocean_database_user.wp_db_user.name
    description = "Nome do usuário no banco"
}

output "wp_db_pwd" {
    value = digitalocean_database_user.wp_db_user.password
    description = "Senha do usuário do banco"
    sensitive = true
    # para mostrar o campo, é preciso executar "terraform output wp_db_pwd"
}
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# provider "digitalocean" {
#   token = var.do_token
# }

resource "digitalocean_vpc" "wp_net" {
  name   = "wp-net"
  region = var.region
}

resource "digitalocean_loadbalancer" "wp_lb" {
  name   = "wp-lb"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path     = "/"
  }

  vpc_uuid = digitalocean_vpc.wp_net.id

  droplet_ids = digitalocean_droplet.vm_wp[*].id
}

/* resource "digitalocean_ssh_key" "rsa" {
  name       = "rsa"
  public_key = file("~/.ssh/id_rsa.pub")
}
 */
resource "digitalocean_droplet" "vm_wp" {
  image    = "ubuntu-22-04-x64"
  name     = "vm-wp-${count.index + 1}"
  region   = var.region
  size     = "s-2vcpu-2gb"
  vpc_uuid = digitalocean_vpc.wp_net.id
  count    = var.wp_vm_count
  ssh_keys = [var.vms_ssh]
}

resource "digitalocean_droplet" "vm_nfs" {
  image    = "ubuntu-22-04-x64"
  name     = "vm-nfs"
  region   = var.region
  size     = "s-2vcpu-2gb"
  vpc_uuid = digitalocean_vpc.wp_net.id
  ssh_keys = [var.vms_ssh]
}

resource "digitalocean_database_db" "wp_db" {
  cluster_id = digitalocean_database_cluster.wp_mysql.id
  name       = "wp-db"
}

resource "digitalocean_database_cluster" "wp_mysql" {
  name                 = "wp-mysql"
  engine               = "mysql"
  version              = "8"
  size                 = "db-s-1vcpu-1gb"
  region               = var.region
  node_count           = 1
  private_network_uuid = digitalocean_vpc.wp_net.id
}

resource "digitalocean_database_user" "wp_db_user" {
  name       = "wordpress"
  cluster_id = digitalocean_database_cluster.wp_mysql.id
}


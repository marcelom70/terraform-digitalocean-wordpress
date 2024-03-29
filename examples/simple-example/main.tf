terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "rsa" {
  name       = "rsa"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "wp_stack" {
  source  = "marcelom70/wordpress/digitalocean"
  version = "1.0.0"
  vms_ssh = digitalocean_ssh_key.rsa.fingerprint
  wp_vm_count = 2 
}

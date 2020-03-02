resource "digitalocean_droplet" "gitlab_runner" {
  image              = "coreos-stable"
  name               = var.runner_name
  region             = var.cloud_region
  size               = var.droplet_size
  private_networking = true
  ssh_keys           = [data.digitalocean_ssh_key.ssh_key.id]
  user_data          = data.ignition_config.coreos_runner_ign.rendered
}

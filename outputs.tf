output "gitlab_runner_address" {
  value = digitalocean_droplet.gitlab_runner.ipv4_address
}

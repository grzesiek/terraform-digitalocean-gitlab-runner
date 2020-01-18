variable "gitlab_address" {}
variable "gitlab_runner_registration_token" {}

resource "digitalocean_ssh_key" "ssh_key" {
  name       = "My Key"
  public_key = file("/home/me/.ssh/id_rsa.pub")
}

resource "digitalocean_droplet" "gitlab_runner_01" {
  image              = "coreos-stable"
  name               = "gitlab-runner-01"
  region             = "ams3"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys           = [digitalocean_ssh_key.ssh_key.id]
  user_data          = data.ignition_config.coreos_runner_ign.rendered
}

data "ignition_filesystem" "root" {
  name = "root"
  path = "/"
}

data "ignition_systemd_unit" "gitlab_runner_service" {
  name    = "gitlab-runner.service"
  enabled = true
  content = <<-CFG
  [Service]
  Type=simple
  Restart=always
  RestartSec=30
  ExecStart=/usr/bin/docker run --rm --name gitlab-runner  \
    -v /home/core/gitlab-runner:/etc/gitlab-runner         \
    -v /var/run/docker.sock:/var/run/docker.sock           \
    gitlab/gitlab-runner:latest

  [Install]
  WantedBy=multi-user.target
  CFG
}

data "ignition_systemd_unit" "gitlab_runner_register_service" {
  name    = "gitlab-runner-register.service"
  enabled = true
  content = <<-CFG
  [Unit]
  Before=gitlab-runner.service
  ConditionPathExists=!/home/core/gitlab-runner/config.toml
  [Service]
  Type=simple
  Restart=on-failure
  RestartSec=60
  ExecStart=/usr/bin/docker run --rm                               \
    -v /home/core/gitlab-runner:/etc/gitlab-runner                 \
    gitlab/gitlab-runner register --non-interactive                \
    --url "${var.gitlab_address}"                                  \
    --registration-token "${var.gitlab_runner_registration_token}" \
    --name gitlab_runner_01                                        \
    --executor docker                                              \
    --docker-image "alpine:latest"                                 \
    --locked=false                                                 \
    --run-untagged=false                                           \
    --docker-privileged=false                                      \
    --tag-list docker

  [Install]
  WantedBy=multi-user.target
  CFG
}


data "ignition_config" "coreos_runner_ign" {
  systemd = [
    data.ignition_systemd_unit.gitlab_runner_service.rendered,
    data.ignition_systemd_unit.gitlab_runner_register_service.rendered,
  ]
}

output "gitlab_runner_address" {
  value = digitalocean_droplet.gitlab_runner_01.ipv4_address
}

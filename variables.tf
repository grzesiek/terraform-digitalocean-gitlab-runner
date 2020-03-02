variable "runner_name" {
  description = "The name of the GitLab Runner"
  type        = string
  default     = "gitlab-runner-01"
}

variable "gitlab_address" {
  description = "Address of GitLab instance eg. https://gitlab.example.com"
  type        = string
}

variable "registration_token" {
  description = "The Runner registration that can be found in the GitLab UI"
  type        = string
}

variable "ssh_key_name" {
  description = "The name of a SSH key that will be added to authorized keys"
  type        = string
}

variable "cloud_region" {
  description = "DigitalOcean region slug eg. sfo2"
  type        = string
  default     = "ams3"
}

variable "droplet_size" {
  description = "DigitalPcean droplet size slug eg. s-1vcpu-1gb"
  type        = string
  default     = "s-1vcpu-1gb"
}

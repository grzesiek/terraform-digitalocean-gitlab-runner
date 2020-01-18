# GitLab Runner Terraform on DigitalOcean

This is a simple Terraform config that makes it easier to create a new droplet
on DigitalOcean, register and start GitLab Runner there.

## Usage

1. In `gitlab_runner.tf` edit `ssh_key` resource to point it to your public SSH
   RSA key
1. Insert you DigitalOcean API token, GitLab URL and GitLab Runner Registration
   token into `terraform.tfvars`
1. Add `*.tfvars` entry to `.gitignore` to avoid commiting your tokens to a Git
   repository
1. Run `terraform apply` :tada:

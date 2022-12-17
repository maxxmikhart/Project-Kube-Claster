terraform {
  backend "gcs" {
    bucket = "terraform-project-farrukh90"
    prefix = "/dev/mnt/farrukh90/project_infrastructure/vault-demo"
  }
}

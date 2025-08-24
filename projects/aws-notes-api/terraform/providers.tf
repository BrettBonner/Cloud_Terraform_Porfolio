provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "notes-api"
      ManagedBy = "terraform"
      Env       = var.env
      Owner     = var.owner
    }
  }
}

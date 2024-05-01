terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.12, < 6.0.0"
    }
  }

  cloud {
    organization = "yohandev"

    workspaces {
      name = "sample-terraform-workspace"
    }
  }
}

provider "github" {
  owner = "turo"
}

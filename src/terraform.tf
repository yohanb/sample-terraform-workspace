terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.4.0"
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

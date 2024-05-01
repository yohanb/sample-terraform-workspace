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
  app_auth {
          id              = var.app_id              # or `GITHUB_APP_ID`
          installation_id = var.app_installation_id # or `GITHUB_APP_INSTALLATION_ID`
          pem_file        = var.app_pem_file        # or `GITHUB_APP_PEM_FILE`
      }
}

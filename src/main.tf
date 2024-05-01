data "http" "worldtime" {
  url = "http://worldtimeapi.org/api/timezone/America/Toronto"
}

output "worldtime" {
value = data.http.worldtime.response_body
}

resource "local_file" "worldtime" {
  content  = data.http.worldtime.response_body
  filename = "${path.module}/worldtime.json"
}

module "test" {
  source = "./modules/repo"

  name        = "test-repo-yohan2"
  description = "test repo using GitHub app credentials for the provider"
  owner       = "devops"
  template    = {
      owner      = "turo"
      repository = "tf-system-template"
    }
}

# resource "github_actions_repository_access_level" "default" {
#   // Access policy only applies to internal and private repositories
#   access_level = "organization"
#   repository   = ""
# }
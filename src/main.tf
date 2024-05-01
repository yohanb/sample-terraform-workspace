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

  name        = "test-repo-yohan"
  description = "test repo using GitHub app credentials for the provider"
  owner       = "devops"
  template    = "tf-system-template"
}
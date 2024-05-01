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
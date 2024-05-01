output "name" {
  value       = github_repository.this.name
  description = "Repository name."
}
output "full_name" {
  value       = github_repository.this.full_name
  description = "A string of the form 'orgname/reponame'."
}

output "owner" {
  value       = var.owner
  description = "Owning team ID or slug."
}

output "default_branch" {
  value       = var.default_branch
  description = "Default branch name."
}

output "repo_id" {
  value       = github_repository.this.repo_id
  description = "Repository ID."
}

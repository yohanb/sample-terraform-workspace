# (Required) The name of the repository.
variable "name" {
  type = string
}

# (Required) A description of the repository.
variable "description" {
  type = string
}

variable "homepage_url" {
  type    = string
  default = "https://turo.com"
}

# (Optional) The owning team ID or slug. (default: DevOps)
variable "owner" {
  type = string
  # The resource for the DevOps team is in the parent, but we want to make
  # DevOps the default owner for repositories, so we have to hard-code it here.
  default = "2465959"
}

# (Optional) The permission group to assign to the owning team.
variable "owner_permission" {
  type    = string
  default = "admin"
}

# (Optional) Set to false to tell GitHub that this repository should have
# no branch protections on its default branch. Note var.protected_branches takes precedence
variable "enable_default_branch_protections" {
  type    = bool
  default = true
}

variable "protected_branches" {
  type = map(object({
    allow_force_pushes              = bool
    allows_deletions                = bool
    dismiss_stale_reviews           = bool
    enforce_admins                  = bool
    require_code_owner_reviews      = bool
    require_signed_commits          = bool
    require_up_to_date_before_merge = bool
    required_approving_review_count = number
    require_linear_history          = bool
    required_status_checks          = list(string)
    pull_request_bypassers          = list(string)
  }))
  default     = null
  description = "Set of branch protection rules to apply to each pattern. The key is used as the branch pattern. Default branch protection is controlled via the other branch protection variables"
}

# (Optional) Set to true to tell GitHub that this repository does not
# allow branches that are out of date to be directly merged to the
# default branch.
variable "require_default_branch_up_to_date_before_merge" {
  type    = bool
  default = false
}

# (Optional) Set to true to tell GitHub that this repository does allow
# merge commit in branch protections.
variable "allow_merge_commit" {
  type    = bool
  default = false
}

# (Optional) Set to false to tell GitHub that this repository does not
# allow automatic merging.
variable "allow_auto_merge" {
  type    = bool
  default = true
}

# (Optional) Set to false to tell GitHub that this repository does not allow
# rebase merging.
variable "allow_rebase_merge" {
  type    = bool
  default = true
}

# (Optional) Set to true to tell GitHub that this repository does allow
# squash merging.
variable "allow_squash_merge" {
  type    = bool
  default = false
}

# (Optional) Set to true to tell GitHub that this branch is allowed to be
# deleted.
variable "allows_deletions" {
  type    = bool
  default = false
}

# (Optional) List of actor Name/IDs that can bypass pull request requirements
variable "pull_request_bypassers" {
  type    = list(string)
  default = []
}

# (Optional) Set to true to tell GitHub that this repository does allow
# forcible pushing.
variable "allows_force_pushes" {
  type    = bool
  default = false
}

# (Optional) Map of team ids to grant access to this repository and their
# permission levels. Must be one of pull, triage, push, maintain, or admin.
variable "teams" {
  type    = map(any)
  default = {}
}

# (Optional) Can be public or private. If your organization is associated with
# an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise
# Server 2.20+, visibility can also be internal. The visibility parameter
# overrides the private parameter.
variable "visibility" {
  type    = string
  default = "private"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Invalid value. Must be public, private, or internal."
  }
}

# (Optional) Set to true to tell GitHub that this is a template repository.
variable "is_template" {
  type    = bool
  default = false
}

# (Optional) Use the name of the template without the extension. For example,
# "Haskell".
# https://github.com/github/gitignore
variable "gitignore_template" {
  type    = string
  default = null
}

# (Optional) Use the name of the template without the extension. For example,
# "mit" or "mpl-2.0".
# https://github.com/github/choosealicense.com/tree/gh-pages/_licenses
variable "license_template" {
  type    = string
  default = null
}

# (Optional) Set to true to archive the repository
variable "archived" {
  type    = bool
  default = false
}

# (Optional) Set to true to archive the repository instead of deleting on
# destroy.
variable "archive_on_destroy" {
  type    = bool
  default = true
}

# (Optional) The list of topics of the repository.
variable "topics" {
  type    = list(string)
  default = []
}

# (Optional) Use a template repository to create this resource. See Template
# Repositories below for details.
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository#template-repositories
variable "template" {
  type     = object({ owner = string, repository = string })
  nullable = true
  default  = null
}

# (Optional) Default branch name.
variable "default_branch" {
  type    = string
  default = "main"
}

# (Optional) The list of status checks to require in order to merge into this
# branch. "List" & "Test" checks are required by default.
variable "required_status_checks" {
  type    = list(string)
  default = ["Lint", "Test"]
}

# (Optional) Dismiss approved reviews automatically when a new commit is pushed.
# Defaults to false.
variable "dismiss_stale_reviews" {
  type    = bool
  default = false
}

# (Optional) Require an approved review in pull requests including files with a
# designated code owner. Defaults to true.
variable "require_code_owner_reviews" {
  type    = bool
  default = true
}

# (Optional) Require x number of approvals to satisfy branch protection
# requirements. If this is specified it must be a number between 1-6. Defaults
# to 1.
variable "required_approving_review_count" {
  type    = number
  default = 1
}

# (Internal) @turo/ops-bots team ID - Do not override!
# This is a reference so we can attach it to every repo. We could probably
# convert this to pull remote state, but that would create a closed cycle and
# not be super useful here.
variable "bots_team" {
  type    = string
  default = "2508810"
}

variable "enforce_admins" {
  type    = bool
  default = false
}

variable "required_linear_history" {
  description = "default=true; Boolean, setting this to true enforces a linear commit Git history, which prevents anyone from pushing merge commits to a branch"
  type        = bool
  default     = true
}

variable "coveralls_enabled" {
  type        = bool
  default     = false
  description = "default=false; setting this to true will add coveralls as read-only collaborator to the repo with read-only permission"
}

variable "enable_issues" {
  type        = bool
  default     = true
  description = "default=true; setting this to true will enable issues on the repo"
}


variable "github_actions_repository_access_level" {
  type        = string
  default     = "none"
  description = "Default none means the access is only possible from workflows in this repository. Other options are user, organization, enterprise"
}

# Change Events Webhook Variables
variable "change_events_webhook_enabled" {
  type        = bool
  default     = false
  description = "default=false; setting this to true will add a webhook to report PR merge Change Events to PagerDuty."
}

variable "incident_workflow_webhook_authentication_secret" {
  type        = string
  default     = ""
  description = "The required Turo Incident Workflow Webhook Authentication Secret to validate the change events from this repository's webhook. (Note the change-event webhook lives under the incident-workflow repo."
  sensitive   = true

  validation {
    condition     = var.change_events_webhook_enabled ? length(var.incident_workflow_webhook_authentication_secret) > 0 : true
    error_message = "You must specify a value for incident_workflow_webhook_authentication_secret if change_events_webhook_enabled is true."
  }
}

variable "labels" {
  type = list(object({
    name  = string
    color = optional(string, "FF0000")
  }))
  description = "Creates labels for the repository, (optional) color must be a hex code without the leading '#' (eg. FF0000)"
  default     = []
}

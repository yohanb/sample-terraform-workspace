# This module contains resources for creating repositories with sane defaults

locals {
  # This resource is in the parent, so we have to hard code it here to get the ID
  engineers_team_id = "2116357"
  # Provide default "push" permissions for Engineers... this will be overridden
  # if another permission is set. If in the situation that the owners of the repo are the "Engineers" group, then the
  # engineers group is removed here.
  teams    = { for k, v in merge({ (local.engineers_team_id) : "push" }, var.teams) : k => v if k != var.owner }
  topics   = toset([for topic in var.topics : lower(topic)])
  template = var.template != null ? [var.template] : []
  protected_branches = merge(
    var.enable_default_branch_protections ? {
      (var.default_branch) = {
        allow_force_pushes              = var.allows_force_pushes
        allows_deletions                = var.allows_deletions
        dismiss_stale_reviews           = var.dismiss_stale_reviews
        enforce_admins                  = var.enforce_admins
        require_code_owner_reviews      = var.require_code_owner_reviews
        require_signed_commits          = false
        require_up_to_date_before_merge = var.require_default_branch_up_to_date_before_merge
        required_approving_review_count = var.required_approving_review_count
        require_linear_history          = var.required_linear_history
        required_status_checks          = concat(var.required_status_checks, var.coveralls_enabled ? ["coverage/coveralls"] : [])
        pull_request_bypassers          = var.pull_request_bypassers
      }
    } : {},
    var.protected_branches
  )

  # Change Event Webhook vars
  change_events_webhook_url = "https://18av6sp6d3.execute-api.us-east-1.amazonaws.com/prod/change-event"

  # default labels that get added to all repos
  default_issue_labels = [
    {
      name  = "prerelease"
      color = "43D100" # green
    }
  ]

  # combining default labels with input labels
  all_issue_labels = concat(var.labels, local.default_issue_labels)
}

resource "github_repository" "this" {
  name         = var.name
  description  = var.description
  homepage_url = var.homepage_url

  # Unused since visibility overrides it
  # private = true
  visibility = var.visibility

  # Defaults for repo
  # Issues, Projects, and Wiki should all be in JIRA
  has_issues   = var.enable_issues
  has_projects = false
  has_wiki     = false

  # Allow template repo creation
  is_template = var.is_template
  # Allow template use, but we have to populate from a variable to a block which
  # means it's dynamic time
  dynamic "template" {
    for_each = local.template

    content {
      owner      = template.value["owner"]
      repository = template.value["repository"]
    }
  }

  # Merging, rebasing etc.
  allow_auto_merge       = var.allow_auto_merge
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = true

  # Deprecated, but disabled
  has_downloads = false

  # Make a first commit when the repo is created so it can be cloned right away
  auto_init          = true
  gitignore_template = var.gitignore_template
  license_template   = var.license_template

  # Lifecycle settings
  archived           = var.archived
  archive_on_destroy = var.archive_on_destroy

  # Metadata
  topics = local.topics

  lifecycle {
    ignore_changes = [template]
  }
}

# Force creation of main branch
# TBD(Jake): The auto_init flag in the repository resource will create an
# initial commit so the repo is cloneable. This also creates a default branch
# based on the Org settings ("main" for us). This resource will fail to recreate
# the branch with a 422 error.
#
# It is preferable that the default branch is not imported into Terraform at
# creation time since that requires manual intervention to get the Apply to
# complete. We should revisit this behavior if we change our minds.
#
# This requires that var.default_branch be set manually.
#
# resource "github_branch" "default" {
#   repository = github_repository.this.name
#   branch     = var.default_branch
# }

# Force default branch to main
resource "github_branch_default" "default" {
  repository = github_repository.this.name
  # See above re: default branch
  # branch     = github_branch.default.branch
  branch = var.default_branch
}

# Branch protections for default branch
resource "github_branch_protection" "default" {
  for_each = local.protected_branches

  repository_id = github_repository.this.name

  # Identifies the protection rule pattern
  pattern = each.key
  # Enforces status checks for repository administrators.
  enforce_admins = each.value.enforce_admins
  # If true, allows the branch to be deleted.
  allows_deletions = each.value.allows_deletions
  # Disallow force-push history rewrites
  allows_force_pushes = each.value.allow_force_pushes

  # Would require all commits to be signed with PGP
  require_signed_commits = false

  required_linear_history = each.value.require_linear_history

  required_status_checks {
    # Conditionally require branches be up to date before merging
    # to the default branch.
    strict = each.value.require_up_to_date_before_merge
    # Status checks which are required
    # TBD: What values are used here? Where are these defined? Per-repo CI?
    # Example was "ci/travis".
    contexts = each.value.required_status_checks
  }

  required_pull_request_reviews {
    # If true, dismiss approvals when changes are pushed
    dismiss_stale_reviews = each.value.dismiss_stale_reviews
    # If false, codeowner is not enforced
    require_code_owner_reviews = each.value.require_code_owner_reviews
    # At least this many approvals are needed
    required_approving_review_count = each.value.required_approving_review_count
    # If provided, the list of actor Name/IDs that can bypass pull request requirements
    pull_request_bypassers = each.value.pull_request_bypassers
  }
}

# Create the ownership association for this repository
resource "github_team_repository" "owner" {
  repository = github_repository.this.name
  team_id    = var.owner
  permission = var.owner_permission
}

# Associate the @turo/ops-bots team with every repository
resource "github_team_repository" "bots" {
  repository = github_repository.this.name
  team_id    = var.bots_team
  permission = "admin"
}

# Allow associating other teams with this repository
resource "github_team_repository" "team" {
  repository = github_repository.this.name

  for_each   = local.teams
  team_id    = each.key
  permission = each.value
}

resource "github_repository_collaborator" "coverall_collaborator" {
  count = var.coveralls_enabled ? 1 : 0

  repository = github_repository.this.name
  username   = "coveralls"
  permission = "pull"
}

resource "github_actions_repository_access_level" "default" {
  // Access policy only applies to internal and private repositories
  count        = contains(["private", "internal"], var.visibility) ? 1 : 0
  access_level = var.github_actions_repository_access_level
  repository   = github_repository.this.name
}

# Allow adding a webhook to report PR merge Change Events to PagerDuty.
resource "github_repository_webhook" "change_events" {
  count = var.change_events_webhook_enabled ? 1 : 0

  repository = github_repository.this.name

  configuration {
    url          = local.change_events_webhook_url
    content_type = "form"
    secret       = var.incident_workflow_webhook_authentication_secret
  }

  events = ["pull_request"]
}

resource "github_issue_label" "github_issue_labels" {
  for_each = { for label in local.all_issue_labels : label.name => label }

  repository = var.name
  name       = each.value.name
  color      = each.value.color
}

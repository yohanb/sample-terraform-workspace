# repo module

This module provides a consistent and standardized way to create Turo
repositories using Terraform.

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.12, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 5.45.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_repository_access_level.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_repository_access_level) | resource |
| [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_branch_protection.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_issue_label.github_issue_labels](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_collaborator.coverall_collaborator](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) | resource |
| [github_repository_webhook.change_events](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [github_team_repository.bots](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_team_repository.owner](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_team_repository.team](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | (Optional) Set to false to tell GitHub that this repository does not allow automatic merging. | `bool` | `true` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | (Optional) Set to true to tell GitHub that this repository does allow merge commit in branch protections. | `bool` | `false` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | (Optional) Set to false to tell GitHub that this repository does not allow rebase merging. | `bool` | `true` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | (Optional) Set to true to tell GitHub that this repository does allow squash merging. | `bool` | `false` | no |
| <a name="input_allows_deletions"></a> [allows\_deletions](#input\_allows\_deletions) | (Optional) Set to true to tell GitHub that this branch is allowed to be deleted. | `bool` | `false` | no |
| <a name="input_allows_force_pushes"></a> [allows\_force\_pushes](#input\_allows\_force\_pushes) | (Optional) Set to true to tell GitHub that this repository does allow forcible pushing. | `bool` | `false` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | (Optional) Set to true to archive the repository instead of deleting on destroy. | `bool` | `true` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | (Optional) Set to true to archive the repository | `bool` | `false` | no |
| <a name="input_bots_team"></a> [bots\_team](#input\_bots\_team) | (Internal) @turo/ops-bots team ID - Do not override! This is a reference so we can attach it to every repo. We could probably convert this to pull remote state, but that would create a closed cycle and not be super useful here. | `string` | `"2508810"` | no |
| <a name="input_change_events_webhook_enabled"></a> [change\_events\_webhook\_enabled](#input\_change\_events\_webhook\_enabled) | default=false; setting this to true will add a webhook to report PR merge Change Events to PagerDuty. | `bool` | `false` | no |
| <a name="input_coveralls_enabled"></a> [coveralls\_enabled](#input\_coveralls\_enabled) | default=false; setting this to true will add coveralls as read-only collaborator to the repo with read-only permission | `bool` | `false` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | (Optional) Default branch name. | `string` | `"main"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Required) A description of the repository. | `string` | n/a | yes |
| <a name="input_dismiss_stale_reviews"></a> [dismiss\_stale\_reviews](#input\_dismiss\_stale\_reviews) | (Optional) Dismiss approved reviews automatically when a new commit is pushed. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_default_branch_protections"></a> [enable\_default\_branch\_protections](#input\_enable\_default\_branch\_protections) | (Optional) Set to false to tell GitHub that this repository should have no branch protections on its default branch. Note var.protected\_branches takes precedence | `bool` | `true` | no |
| <a name="input_enable_issues"></a> [enable\_issues](#input\_enable\_issues) | default=true; setting this to true will enable issues on the repo | `bool` | `true` | no |
| <a name="input_enforce_admins"></a> [enforce\_admins](#input\_enforce\_admins) | n/a | `bool` | `false` | no |
| <a name="input_github_actions_repository_access_level"></a> [github\_actions\_repository\_access\_level](#input\_github\_actions\_repository\_access\_level) | Default none means the access is only possible from workflows in this repository. Other options are user, organization, enterprise | `string` | `"none"` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | (Optional) Use the name of the template without the extension. For example, "Haskell". https://github.com/github/gitignore | `string` | `null` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | n/a | `string` | `"https://turo.com"` | no |
| <a name="input_incident_workflow_webhook_authentication_secret"></a> [incident\_workflow\_webhook\_authentication\_secret](#input\_incident\_workflow\_webhook\_authentication\_secret) | The required Turo Incident Workflow Webhook Authentication Secret to validate the change events from this repository's webhook. (Note the change-event webhook lives under the incident-workflow repo. | `string` | `""` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | (Optional) Set to true to tell GitHub that this is a template repository. | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Creates labels for the repository, (optional) color must be a hex code without the leading '#' (eg. FF0000) | <pre>list(object({<br>    name  = string<br>    color = optional(string, "FF0000")<br>  }))</pre> | `[]` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | (Optional) Use the name of the template without the extension. For example, "mit" or "mpl-2.0". https://github.com/github/choosealicense.com/tree/gh-pages/_licenses | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the repository. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | (Optional) The owning team ID or slug. (default: DevOps) | `string` | `"2465959"` | no |
| <a name="input_owner_permission"></a> [owner\_permission](#input\_owner\_permission) | (Optional) The permission group to assign to the owning team. | `string` | `"admin"` | no |
| <a name="input_protected_branches"></a> [protected\_branches](#input\_protected\_branches) | Set of branch protection rules to apply to each pattern. The key is used as the branch pattern. Default branch protection is controlled via the other branch protection variables | <pre>map(object({<br>    allow_force_pushes              = bool<br>    allows_deletions                = bool<br>    dismiss_stale_reviews           = bool<br>    enforce_admins                  = bool<br>    require_code_owner_reviews      = bool<br>    require_signed_commits          = bool<br>    require_up_to_date_before_merge = bool<br>    required_approving_review_count = number<br>    require_linear_history          = bool<br>    required_status_checks          = list(string)<br>    pull_request_bypassers          = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_pull_request_bypassers"></a> [pull\_request\_bypassers](#input\_pull\_request\_bypassers) | (Optional) List of actor Name/IDs that can bypass pull request requirements | `list(string)` | `[]` | no |
| <a name="input_require_code_owner_reviews"></a> [require\_code\_owner\_reviews](#input\_require\_code\_owner\_reviews) | (Optional) Require an approved review in pull requests including files with a designated code owner. Defaults to true. | `bool` | `true` | no |
| <a name="input_require_default_branch_up_to_date_before_merge"></a> [require\_default\_branch\_up\_to\_date\_before\_merge](#input\_require\_default\_branch\_up\_to\_date\_before\_merge) | (Optional) Set to true to tell GitHub that this repository does not allow branches that are out of date to be directly merged to the default branch. | `bool` | `false` | no |
| <a name="input_required_approving_review_count"></a> [required\_approving\_review\_count](#input\_required\_approving\_review\_count) | (Optional) Require x number of approvals to satisfy branch protection requirements. If this is specified it must be a number between 1-6. Defaults to 1. | `number` | `1` | no |
| <a name="input_required_linear_history"></a> [required\_linear\_history](#input\_required\_linear\_history) | default=true; Boolean, setting this to true enforces a linear commit Git history, which prevents anyone from pushing merge commits to a branch | `bool` | `true` | no |
| <a name="input_required_status_checks"></a> [required\_status\_checks](#input\_required\_status\_checks) | (Optional) The list of status checks to require in order to merge into this branch. "List" & "Test" checks are required by default. | `list(string)` | <pre>[<br>  "Lint",<br>  "Test"<br>]</pre> | no |
| <a name="input_teams"></a> [teams](#input\_teams) | (Optional) Map of team ids to grant access to this repository and their permission levels. Must be one of pull, triage, push, maintain, or admin. | `map(any)` | `{}` | no |
| <a name="input_template"></a> [template](#input\_template) | (Optional) Use a template repository to create this resource. See Template Repositories below for details. https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository#template-repositories | `object({ owner = string, repository = string })` | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | (Optional) The list of topics of the repository. | `list(string)` | `[]` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | (Optional) Can be public or private. If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, visibility can also be internal. The visibility parameter overrides the private parameter. | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_branch"></a> [default\_branch](#output\_default\_branch) | Default branch name. |
| <a name="output_full_name"></a> [full\_name](#output\_full\_name) | A string of the form 'orgname/reponame'. |
| <a name="output_name"></a> [name](#output\_name) | Repository name. |
| <a name="output_owner"></a> [owner](#output\_owner) | Owning team ID or slug. |
| <a name="output_repo_id"></a> [repo\_id](#output\_repo\_id) | Repository ID. |
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->

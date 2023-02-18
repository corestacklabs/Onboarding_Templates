output "list_proj" {
  description = "Project List"
  value = data.google_projects.my-org-projects.projects
}
terraform {
  cloud {
    organization = "KDvops"
    workspaces {
      name = var.workspace_name
    }
  }
}

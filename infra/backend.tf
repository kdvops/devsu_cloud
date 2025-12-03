terraform {
  cloud {
    organization = "KDvops"
    workspaces {
      name = "#{ENVIRONMENT}#"
      #name = "devsarrollo"
}
  }
}

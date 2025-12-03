terraform {
  cloud {
    organization = "KDvops"
    workspaces {
      name = "#{ENVIRONMENT}#"
      #name = "devsarrollo"
}
  }
}


#terraform {
#  backend "local" {
#    path = "state/terraform.tfstate"
#  }
#}

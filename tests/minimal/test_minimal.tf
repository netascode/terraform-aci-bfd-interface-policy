terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant = aci_rest.fvTenant.content.name
  name   = "BFD1"
}

data "aci_rest" "bfdIfPol" {
  dn = "uni/tn-${aci_rest.fvTenant.content.name}/bfdIfPol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "bfdIfPol" {
  component = "bfdIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest.bfdIfPol.content.name
    want        = module.main.name
  }
}

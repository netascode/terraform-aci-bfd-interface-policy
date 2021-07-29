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

  tenant                    = aci_rest.fvTenant.content.name
  name                      = "BFD1"
  description               = "My Description"
  subinterface_optimization = true
  detection_multiplier      = 10
  echo_admin_state          = true
  echo_rx_interval          = 100
  min_rx_interval           = 100
  min_tx_interval           = 100
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

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.bfdIfPol.content.descr
    want        = "My Description"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest.bfdIfPol.content.ctrl
    want        = "opt-subif"
  }

  equal "detectMult" {
    description = "detectMult"
    got         = data.aci_rest.bfdIfPol.content.detectMult
    want        = "10"
  }

  equal "echoAdminSt" {
    description = "echoAdminSt"
    got         = data.aci_rest.bfdIfPol.content.echoAdminSt
    want        = "enabled"
  }

  equal "echoRxIntvl" {
    description = "echoRxIntvl"
    got         = data.aci_rest.bfdIfPol.content.echoRxIntvl
    want        = "100"
  }

  equal "minRxIntvl" {
    description = "minRxIntvl"
    got         = data.aci_rest.bfdIfPol.content.minRxIntvl
    want        = "100"
  }

  equal "minTxIntvl" {
    description = "minTxIntvl"
    got         = data.aci_rest.bfdIfPol.content.minTxIntvl
    want        = "100"
  }
}

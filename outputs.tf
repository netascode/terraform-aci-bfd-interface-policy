output "dn" {
  value       = aci_rest.bfdIfPol.id
  description = "Distinguished name of `bfdIfPol` object"
}

output "name" {
  value       = aci_rest.bfdIfPol.content.name
  description = "BFD interface policy name"
}

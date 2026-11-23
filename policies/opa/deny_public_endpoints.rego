package terraform.deny_public_endpoints

deny[msg] {
  rc := input.resource_changes[_]
  rc.change.after.public_network_access_enabled == true
  msg := sprintf("Resource %s must not enable public network access", [rc.address])
}

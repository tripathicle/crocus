package terraform.protect_stateful_prod

deny[msg] {
  rc := input.resource_changes[_]
  rc.change.actions[_] == "delete"
  contains(rc.type, "database")
  msg := sprintf("Deletion of stateful resource %s is denied in prod", [rc.address])
}

deny[msg] {
  rc := input.resource_changes[_]
  rc.change.actions[_] == "delete"
  contains(rc.type, "storage")
  msg := sprintf("Deletion of storage resource %s is denied in prod", [rc.address])
}

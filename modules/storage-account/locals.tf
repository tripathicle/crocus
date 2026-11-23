locals {
  has_lock      = var.lock_level != null
  container_map = { for c in var.containers : c => c }
}

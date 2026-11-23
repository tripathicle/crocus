locals {
  regions = var.enable_dr ? [var.primary_region, var.dr_region] : [var.primary_region]

  spoke_instances = flatten([
    for app_key, app in var.monolith_apps : [
      for region in local.regions : {
        key       = "${app_key}-${region}"
        app_key   = app_key
        app_name  = app.name
        sku       = app.sku
        instances = app.instances
        region    = region
        is_dr     = region == var.dr_region
        rg_name   = "rg-spoke-${app.name}-${region}"
      }
    ]
  ])

  spoke_map = { for s in local.spoke_instances : s.key => s }
}

locals {
  stage = lookup(var.tags, "Stage", null)
  path  = "/${local.stage}/${var.path}"

  presets           = {
    jwt_deprecated       = {
      special = false
      length  = 9
      lower   = false
      number  = true
    }
    stripe               = {
      length           = 32
      override_special = "_"
    }
    internal_email       = {
      special          = true
      override_special = "@."
      lower            = true
      upper            = false
      number           = false
    }
    internal_alias_email = {
      special          = true
      override_special = "+@."
      lower            = true
      upper            = false
      number           = false
    }
  }
  password_settings = [for p in var.passwords : try(merge(p, lookup(local.presets, lookup(p, "preset"))), p)]
  has_template      = var.password_count > 0 || var.uuid_count > 0
  passwords         = {for i, r in tolist(random_password.this.*.result) : "password_${i}" => r}
  uuids             = {for i, r in tolist(random_uuid.this.*.result) : "uuid_${i}" => r}

  template_vars = merge(local.passwords, local.uuids, var.template_vars)
}

resource "random_uuid" "this" {
  count = var.uuid_count
}

resource "random_password" "this" {
  count = var.password_count

  length           = try(lookup(local.password_settings[count.index], "length"), 12)
  special          = try(lookup(local.password_settings[count.index], "special"), true)
  override_special = try(lookup(local.password_settings[count.index], "override_special"), null)
  lower            = try(lookup(local.password_settings[count.index], "lower"), true)
  upper            = try(lookup(local.password_settings[count.index], "upper"), true)
  number           = try(lookup(local.password_settings[count.index], "number"), true)
}

resource "aws_ssm_parameter" "this" {
  depends_on = [random_password.this]

  name      = local.path
  data_type = "text"
  type      = var.encrypted ? "SecureString" : "String"
  value     = local.has_template ? templatefile("./value.json__tmpl__", local.template_vars) : var.value

  tags = var.tags
}

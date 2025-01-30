
resource "oci_database_autonomous_database" "oci_database_autonomous_database" {
  admin_password                       = base64decode(data.oci_secrets_secretbundle.bundle.secret_bundle_content.0.content)
  autonomous_maintenance_schedule_type = "REGULAR"
  backup_retention_period_in_days      = "60"
  compartment_id                       = var.compartment_id
  compute_count                        = "2"
  compute_model                        = "ECPU"
  data_storage_size_in_tbs             = "1"
  db_name                              = "JSONDB"
  db_tools_details {
    is_enabled = "true"
    name       = "APEX"
  }
  db_tools_details {
    is_enabled = "true"
    name       = "DATABASE_ACTIONS"
  }
  db_tools_details {
    compute_count            = "2"
    is_enabled               = "true"
    max_idle_time_in_minutes = "60"
    name                     = "OML"
  }
  db_tools_details {
    compute_count            = "2"
    is_enabled               = "true"
    max_idle_time_in_minutes = "10"
    name                     = "DATA_TRANSFORMS"
  }
  db_tools_details {
    is_enabled = "true"
    name       = "ORDS"
  }
  db_tools_details {
    is_enabled = "true"
    name       = "MONGODB_API"
  }

  db_version                                     = "23ai"
  db_workload                                    = "AJD"
  display_name                                   = "ADB-Json"
  is_auto_scaling_enabled                        = "true"
  is_auto_scaling_for_storage_enabled            = "false"
  is_dedicated                                   = "false"
  is_mtls_connection_required                    = "false"
  is_preview_version_with_service_terms_accepted = "false"
  license_model                                  = "LICENSE_INCLUDED"
  whitelisted_ips                                = ["0.0.0.0/0"]
}

resource "oci_database_autonomous_database" "oci_database_autonomous_database" {
  admin_password                                 = base64decode(data.oci_secrets_secretbundle.bundle.secret_bundle_content.0.content)
  autonomous_maintenance_schedule_type           = "REGULAR"
  compartment_id                                 = var.compartment_id
  compute_count                                  = "2"
  compute_model                                  = "ECPU"
  data_storage_size_in_gb                        = "1024"
  db_name                                        = "adj"
  db_version                                     = "23ai"
  db_workload                                    = "AJD"
  display_name                                   = "Autonomous-Json"
  is_auto_scaling_enabled                        = "false"
  is_auto_scaling_for_storage_enabled            = "false"
  is_dedicated                                   = "false"
  is_free_tier                                   = "true"
  is_mtls_connection_required                    = "false"
  is_preview_version_with_service_terms_accepted = "false"
  license_model                                  = "LICENSE_INCLUDED"
  whitelisted_ips                                = ["0.0.0.0/0"]

}

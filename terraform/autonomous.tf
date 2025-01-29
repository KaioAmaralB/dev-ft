resource "oci_database_autonomous_database" "json_db" {
  compartment_id           = var.compartment_id
  db_name                  = "JSONDB"
  display_name             = "JSON-ADB"
  db_workload              = "AJD" # Autonomous JSON Database
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1
  admin_password           = base64decode(data.oci_secrets_secretbundle.bundle.secret_bundle_content.0.content)

  is_auto_scaling_enabled     = true
  is_dedicated                = false
  is_free_tier                = false
  whitelisted_ips             = ["0.0.0.0/0"] # Allow all IPs
  is_mtls_connection_required = false

}
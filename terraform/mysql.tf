resource "oci_mysql_mysql_db_system" "mysql_db_system" {
    #Required
    availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
    compartment_id = var.compartment_id
    shape_name = var.mysql_shape_name
    subnet_id = module.oke.worker_subnet_id

    #Optional
    admin_password = base64decode(data.oci_secrets_secretbundle.bundle.secret_bundle_content.0.content)
    admin_username = var.mysql_db_system_admin_username

    provider = oci
}
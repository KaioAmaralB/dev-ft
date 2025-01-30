resource "oci_functions_application" "new_application" {
  compartment_id             = var.compartment_id
  display_name               = var.application_display_name
  subnet_ids                 = [module.oke.pub_lb_subnet_id]
  network_security_group_ids = [module.oke.pub_lb_nsg_id, oci_core_network_security_group.app_network_security_group.id]
}

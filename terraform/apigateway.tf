resource "oci_apigateway_gateway" "devops_gateway" {
  compartment_id             = var.compartment_id
  endpoint_type              = var.api_gateway_type
  subnet_id                  = module.oke.pub_lb_subnet_id
  display_name               = var.api_gateway_name
  network_security_group_ids = [module.oke.pub_lb_nsg_id, oci_core_network_security_group.app_network_security_group.id]
}

resource "oci_functions_application" "new_application" {
    #Required
    compartment_id = var.compartment_id
    display_name = var.application_display_name
    subnet_ids = [oci_core_subnet.oke_lb_subnet[0].id]
}
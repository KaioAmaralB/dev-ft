resource "oci_functions_application" "new_application" {
    compartment_id = var.compartment_id
    display_name = var.application_display_name
    #subnet_ids = [oci_core_subnet.oke_lb_subnet[0].id]
    subnet_ids = ["ocid1.subnet.oc1.sa-saopaulo-1.aaaaaaaahsh6lpnkdh55sjauns35hrj4oagn5d6iajyxerpyewdyahfuzaka"]
}
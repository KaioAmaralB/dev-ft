resource "oci_queue_queue" "oci_queue" {
    compartment_id = var.compartment_id
    display_name = var.queue_display_name
}
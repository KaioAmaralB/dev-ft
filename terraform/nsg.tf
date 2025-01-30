resource "oci_core_network_security_group" "app_network_security_group" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.oke.vcn_id
  display_name   = "app"

}

resource "oci_core_network_security_group_security_rule" "allow_https_inbound" {
  network_security_group_id = oci_core_network_security_group.app_network_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"         # TCP
  source                    = "0.0.0.0/0" # Allow traffic from the internet
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_https_outbound" {
  network_security_group_id = oci_core_network_security_group.app_network_security_group.id
  direction                 = "EGRESS"
  protocol                  = "6"         # TCP
  destination               = "0.0.0.0/0" # Allow traffic to the internet
  destination_type          = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}


resource "oci_core_network_security_group_security_rule" "allow_nsg_inbound" {
  network_security_group_id = oci_core_network_security_group.app_network_security_group.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = module.oke.pub_lb_nsg_id
  source_type               = "NETWORK_SECURITY_GROUP"
}

resource "oci_core_network_security_group_security_rule" "allow_nsg_outbound" {
  network_security_group_id = oci_core_network_security_group.app_network_security_group.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = module.oke.pub_lb_nsg_id
  destination_type          = "NETWORK_SECURITY_GROUP"
}

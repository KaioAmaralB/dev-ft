## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_identity_dynamic_group" "oke_nodes_dg" {
  name           = "${local.app_name_normalized}-oke-cluster-dg-${random_string.deploy_id.result}"
  description    = "${var.app_name} Cluster Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ANY {ALL {instance.compartment.id = '${var.compartment_id}'},ALL {resource.type = 'cluster', resource.compartment.id = '${var.compartment_id}'}, ALL {resource.type = 'devopsbuildpipeline', resource.compartment.id = '${var.compartment_id}'}}"

  provider = oci.home_region

  count = var.create_dynamic_group_for_nodes_in_compartment ? 1 : 0
}

locals {
  oke_nodes_dg     = var.create_dynamic_group_for_nodes_in_compartment ? oci_identity_dynamic_group.oke_nodes_dg.0.name : "void"
  oci_vault_key_id = "void"
  #var.use_encryption_from_oci_vault ? (var.create_new_encryption_key ? oci_kms_key.mushop_key[0].id : var.existent_encryption_key_id) : "void"
  oci_statements = [
    "Allow dynamic-group ${local.oke_nodes_dg} to read metrics in tenancy",
    "Allow dynamic-group ${local.oke_nodes_dg} to read compartments in tenancy",
    "Allow dynamic-group ${local.oke_nodes_dg} to manage repos in tenancy",
    "Allow dynamic-group ${local.oke_nodes_dg} to manage devops-family in tenancy",
    "Allow service vulnerability-scanning-service to read repos in tenancy",
    "Allow service vulnerability-scanning-service to read compartments in tenancy"
  ]
  oci_grafana_logs_statements = [
    "Allow dynamic-group ${local.oke_nodes_dg} to read log-groups in compartment id ${var.compartment_id}",
    "Allow dynamic-group ${local.oke_nodes_dg} to read log-content in compartment id ${var.compartment_id}"
  ]
  # cluster_autoscaler_statements = [
  #   "Allow dynamic-group ${local.oke_nodes_dg} to manage cluster-node-pools in compartment id ${var.compartment_id}",
  #   "Allow dynamic-group ${local.oke_nodes_dg} to manage instance-family in compartment id ${var.compartment_id}",
  #   "Allow dynamic-group ${local.oke_nodes_dg} to use subnets in compartment id ${var.compartment_id}",
  #   "Allow dynamic-group ${local.oke_nodes_dg} to read virtual-network-family in compartment id ${var.compartment_id}",
  #   "Allow dynamic-group ${local.oke_nodes_dg} to use vnics in compartment id ${var.compartment_id}",
  #   "Allow dynamic-group ${local.oke_nodes_dg} to inspect compartments in compartment id ${var.compartment_id}"
  # ]
  allow_oke_use_oci_vault_keys_statements = [
    "Allow service oke to use vaults in compartment id ${var.compartment_id}",
    "Allow service oke to use keys in compartment id ${var.compartment_id} where target.key.id = '${local.oci_vault_key_id}'",
    "Allow dynamic-group ${local.oke_nodes_dg} to use keys in compartment id ${var.compartment_id} where target.key.id = '${local.oci_vault_key_id}'"
  ]

}

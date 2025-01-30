## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_identity_dynamic_group" "oke_nodes_dg" {
  name           = "${local.app_name_normalized}-oke-cluster-dg-${random_string.deploy_id.result}"
  description    = "${var.app_name} Cluster Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = join(" ", local.dynamic_group_rules)

  provider = oci.home_region

}

resource "oci_identity_policy" "test_policy" {
  compartment_id = var.compartment_id
  description    = local.policy_description
  name           = "${local.app_name_normalized}-devops-policy"
  statements     = local.oke-policies
  depends_on     = [oci_identity_dynamic_group.oke_nodes_dg]

  provider = oci.home_region
}

locals {

  oke_nodes_dg = oci_identity_dynamic_group.oke_nodes_dg.name

  oke-policies = concat(local.oci_statements)

  dynamic_group_rules = [
    "ANY {",
    "ALL {instance.compartment.id = '${var.compartment_id}'},",
    "ALL {resource.type = 'cluster', resource.compartment.id = '${var.compartment_id}'},",
    "ALL {resource.type = 'ApiGateway', resource.compartment.id = '${var.compartment_id}'}",
    "}"
  ]
  oci_statements = [
    "Allow dynamic-group ${local.oke_nodes_dg} to use functions-family in compartment id ${var.compartment_id}",
    "Allow dynamic-group ${local.oke_nodes_dg} to use queues in compartment id ${var.compartment_id}",
  ]

  policy_description = "Policy for the devops enviroment"
}

output "policies" {

  value = local.oke-policies

}


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
  #Required
  compartment_id = var.tenancy_ocid
  description    = local.policy_description
  name           = "${local.app_name_normalized}-devops-policy"
  statements     = concat(local.oci_statements)
  depends_on     = [oci_identity_dynamic_group.oke_nodes_dg]

  provider = oci.home_region
}

locals {

  oke_nodes_dg = oci_identity_dynamic_group.oke_nodes_dg.name

  dynamic_group_rules = [
    "ANY {",
    "ALL {instance.compartment.id = '${var.compartment_id}'},",
    "ALL {resource.type = 'cluster', resource.compartment.id = '${var.compartment_id}'},",
    "ALL {resource.type = 'ApiGateway', resource.compartment.id = '${var.compartment_id}'}",
    "}"
  ]
  oci_statements = [
    "Allow dynamic-group ${local.oke_nodes_dg} to use functions-family in compartment id '${var.compartment_id}'",
    "Allow dynamic-group ${local.oke_nodes_dg} to use queues in compartment id '${var.compartment_id}'",
    "Allow service vulnerability-scanning-service to read repos in tenancy",
    "Allow service vulnerability-scanning-service to read compartments in tenancy"
  ]

  policy_description = "Policy for the devops enviroment"
}


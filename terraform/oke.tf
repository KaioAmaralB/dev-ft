## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
module "oke" {

  source = "oracle-terraform-modules/oke/oci"

  home_region = lookup(data.oci_identity_regions.home_region.regions[0], "name")
  region      = var.region
  providers   = { oci.home = oci.home }

  tenancy_id = var.tenancy_ocid

  #   # general oci parameters
  compartment_id = var.compartment_id

  create_drg           = false
  create_bastion       = false
  create_iam_resources = false
  create_operator      = false

  #   #Kubernetes

  kubernetes_version                = var.k8s_version
  cni_type                          = "flannel"
  assign_public_ip_to_control_plane = true
  cluster_type                      = "basic"

  worker_pool_mode = "node-pool"
  worker_pool_size = 1

  worker_pools = {

    var.node_pool_name = {
      description                  = "OKE-managed Node Pool with OKE Oracle Linux 8 image",
      shape                        = var.node_pool_shape,
      size                         = var.num_pool_workers,
      create                       = true,
      ocpus                        = var.node_pool_node_shape_config_ocpus,
      memory                       = var.node_pool_node_shape_config_memory_in_gbs,
      boot_volume_size             = var.node_pool_boot_volume_size_in_gbs,
      os                           = var.image_operating_system,
      os_version                   = var.image_operating_system_version,
    }

  }

  # #Network

  create_vcn                  = false
  load_balancers              = "public"
  control_plane_is_public     = true
  control_plane_allowed_cidrs = ["0.0.0.0/0"]

  subnets = {
  cp       = { id = oci_core_subnet.oke_k8s_endpoint_subnet[0].id }
  pub_lb   = { id = oci_core_subnet.oke_lb_subnet[0].id }
  workers  = { id = oci_core_subnet.oke_nodes_subnet[0].id }
  }

}
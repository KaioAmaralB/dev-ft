## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


# OKE Variables
## OKE Cluster Details

variable "create_new_oke_cluster" {
  default     = true
  description = "Creates a new OKE cluster, node pool and network resources"
}


## OKE Node Pool Details
variable "node_pool_name" {
  default     = "pool1"
  description = "Name of the node pool"
}
variable "k8s_version" {
  default     = "v1.31.1"
  description = "Kubernetes version installed on your master and worker nodes"
}
variable "num_pool_workers" {
  default     = 1
  description = "The number of worker nodes in the node pool. If select Cluster Autoscaler, will assume the minimum number of nodes configured"
}
variable "node_pool_shape" {
  default     = "VM.Standard.A1.Flex"
  description = "A shape is a template that determines the number of OCPUs, amount of memory, and other resources allocated to a newly created instance for the Worker Node"
}
variable "node_pool_node_shape_config_ocpus" {
  default     = "2" # Only used if flex shape is selected
  description = "You can customize the number of OCPUs to a flexible shape"
}
variable "node_pool_node_shape_config_memory_in_gbs" {
  default     = "8" # Only used if flex shape is selected
  description = "You can customize the amount of memory allocated to a flexible shape"
}
variable "node_pool_boot_volume_size_in_gbs" {
  default     = "50"
  description = "Specify a custom boot volume size (in GB)"
}
variable "image_operating_system" {
  default     = "Oracle Linux"
  description = "The OS/image installed on all nodes in the node pool."
}
variable "image_operating_system_version" {
  default     = "8.10"
  description = "The OS/image version installed on all nodes in the node pool."
}

# Network Details
## CIDRs
variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                      = "10.20.0.0/16"
    SUBNET-REGIONAL-CIDR          = "10.20.10.0/24"
    LB-SUBNET-REGIONAL-CIDR       = "10.20.20.0/24"
    ENDPOINT-SUBNET-REGIONAL-CIDR = "10.20.0.0/28"
    ALL-CIDR                      = "0.0.0.0/0"
    PODS-CIDR                     = "10.244.0.0/16"
    KUBERNETES-SERVICE-CIDR       = "10.96.0.0/16"
  }
}


# Create Dynamic Group and Policies
variable "create_dynamic_group_for_nodes_in_compartment" {
  default     = true
  description = "Creates dynamic group of Nodes in the compartment. Note: You need to have proper rights on the Tenancy. If you only have rights in a compartment, uncheck and ask you administrator to create the Dynamic Group for you"
}
variable "existent_dynamic_group_for_nodes_in_compartment" {
  default     = ""
  description = "Enter previous created Dynamic Group for the policies"
}
variable "create_compartment_policies" {
  default     = true
  description = "Creates policies that will reside on the compartment. e.g.: Policies to support Cluster Autoscaler, OCI Logging datasource on Grafana"
}
variable "create_tenancy_policies" {
  default     = true
  description = "Creates policies that need to reside on the tenancy. e.g.: Policies to support OCI Metrics datasource on Grafana"
}

# ORM Schema visual control variables
variable "show_advanced" {
  default = false
}

# App Name Locals
locals {
  app_name_normalized = substr(replace(lower(var.app_name), " ", "-"), 0, 6)
  app_name_for_db     = regex("[[:alnum:]]{1,10}", var.app_name)
}

# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex"
  ]
}

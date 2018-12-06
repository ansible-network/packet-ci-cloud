
variable "project_id" {
  description = "Packet Project ID"
}

variable "packet_facility" {
  description = "Packet facility: US East(ewr1), US West(sjc1), Tokyo (nrt1) or EU(ams1). Default: ewr1"
  default = "ewr1"
}

variable "compute_type" {
  description = "Instance type of OpenStack compute nodes"
  default = "baremetal_2"
}

variable "compute_count" {
  description = "Number of OpenStack compute nodes to deploy"
  default = "1"
}

variable "control_type" {
  description = "Instance type of OpenStack control nodes"
  default = "baremetal_2"
}

variable "control_count" {
  description = "Number of OpenStack control nodes to deploy"
  default = "1"
}

variable "operating_system" {
  description = "Operating System to install across nodes"
  default = "centos_7"
}

variable "cloud_ssh_public_key_path" {
  description = "Path to your public SSH key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "cloud_ssh_key_path" {
  description = "Path to your private SSH key for the project"
  default = "~/.ssh/id_rsa"
}



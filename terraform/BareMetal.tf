resource "packet_device" "compute" {

  count            = "${var.compute_count}"
  hostname         = "${format("compute-%02d", count.index)}"
  operating_system = "${var.operating_system}"
  plan             = "${var.compute_type}"
  tags             = ["openstack-${random_id.cloud.hex}"]


  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facility      = "${var.packet_facility}"
  project_id    = "${var.project_id}"
  billing_cycle = "hourly"

  public_ipv4_subnet_size  = "31"
}

resource "packet_device" "control" {

  count            = "${var.control_count}"
  hostname         = "${format("control-%02d", count.index)}"
  operating_system = "${var.operating_system}"
  plan             = "${var.control_type}"
  tags             = ["openstack-${random_id.cloud.hex}"]

  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facility      = "${var.packet_facility}"
  project_id    = "${var.project_id}"
  billing_cycle = "hourly"

  public_ipv4_subnet_size  = "29"
}

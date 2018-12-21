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
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"

  public_ipv4_subnet_size  = "31"

  connection {
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "${var.operating_system}-${var.control_type}.sh"
    destination = "hardware-setup.sh"
  }

  provisioner "file" {
    source      = "${var.operating_system}.sh"
    destination = "os-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash os-setup.sh > os-setup.out",
      "bash hardware-setup.sh > hardware-setup.out",
      "reboot &"
    ]
  }
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
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"

# enable if elastic IPv4 addresses are required
#  public_ipv4_subnet_size  = "29"

  connection {
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "${var.operating_system}-${var.control_type}.sh"
    destination = "hardware-setup.sh"
  }

  provisioner "file" {
    source      = "${var.operating_system}.sh"
    destination = "os-setup.sh"
  }

  provisioner "file" {
    source      = "deployment_host.sh"
    destination = "deployment_host.sh"
  }

  # private SSH key for OSA to use
  provisioner "file" {
    source      = "${var.cloud_ssh_key_path}"
    destination = "osa_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "bash os-setup.sh > os-setup.out",
      "bash hardware-setup.sh > hardware-setup.out",
      "bash deployment_host.sh > deployment_host.out",
      "reboot &"
    ]
  }
}

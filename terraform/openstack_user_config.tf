data "template_file" "infrastructure_hosts" {
  depends_on = [
    "packet_device.control",
  ]

  count = "${var.control_count}"

  template = <<JSON
$${hostname}:
    ip: $${public_ip}
JSON

  vars {
    public_ip = "${element(packet_device.control.*.access_public_ipv4, count.index)}"
    hostname  = "${element(packet_device.control.*.hostname, count.index)}"
  }
}

data "template_file" "compute_hosts" {
  depends_on = [
    "packet_device.compute",
  ]

  count = "${var.compute_count}"

  template = <<JSON
$${hostname}:
    ip: $${public_ip}
JSON

  vars {
    public_ip = "${element(packet_device.compute.*.access_public_ipv4, count.index)}"
    hostname  = "${element(packet_device.compute.*.hostname, count.index)}"
  }
}

data "template_file" "openstack_user_config" {
  template = "${file("${path.module}/openstack_user_config-yml.tpl")}"

  vars {
    infrastructure_hosts = "${join(",", data.template_file.infrastructure_hosts.*.rendered)}"
    compute_hosts        = "${join(",", data.template_file.compute_hosts.*.rendered)}"

    control_hostnames = "${jsonencode(join(",", packet_device.control.*.hostname))}"
    control_public_ips = "${join(",",packet_device.control.*.access_public_ipv4)}"
    compute_public_ips = "${join(",",packet_device.compute.*.access_public_ipv4)}"
#    control_public_ips = "${jsonencode(split(",", packet_device.control.*.access_public_ipv4))}"
#    compute_public_ips = "${jsonencode(split(",", packet_device.compute.*.access_public_ipv4))}"
  }
}

resource "null_resource" "inventory" {
  triggers {
    template_rendered = "${data.template_file.openstack_user_config.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.openstack_user_config.rendered}' > openstack_user_config.yml"
  }
}

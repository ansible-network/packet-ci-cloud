output "Cloud ID Tag" {
  value = "${random_id.cloud.hex}"
}

output "Compute IPs" {
  value = "${packet_device.compute.*.access_public_ipv4}"
}

output "Control IPs" {
  value = "${packet_device.control.*.access_public_ipv4}"
}

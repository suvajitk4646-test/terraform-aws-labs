output "wazuh_dashboard_url" {
  value = "https://${module.compute.siem_public_ip}"
}
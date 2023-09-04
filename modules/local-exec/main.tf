resource "null_resource" "name" {
  provisioner "local-exec" {
    command     = "Start-Sleep -Seconds 300"
    interpreter = ["PowerShell", "-Command"]
  }
}
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

################      Source bloco       ################
source "virtualbox-iso" "ubuntu" {
  boot_command            = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/", "<enter>"]
  boot_wait               = "5s"
  guest_os_type           = "ubuntu-64"
  headless                = false
  http_directory          = "http"
  iso_checksum            = "${var.check_sum_18}"
  iso_url                 = "${var.ubuntu_18}"
  vm_name                 = "${var.vm_name}"
  memory                  = 1024
  ssh_username            = "${var.username}"
  ssh_password            = "${var.password}"
  ssh_timeout             = "60m"
  ssh_handshake_attempts  = "20"
  format                  = "ovf"
  disable_shutdown        = false
  shutdown_command        = "echo '${var.password}'|sudo -S shutdown -P now"
  output_directory        = "${var.output_vbox}-${var.vm_name}"
}

build {
  sources = [
              "source.virtualbox-iso.ubuntu"
  ]

  provisioner "shell" {
    execute_command = "echo '${var.password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    only            = ["virtualbox-iso.ubuntu"]
    script          = "scripts/setup.sh"
  }

  post-processor "manifest" {
    output     = "${var.output_vbox}-${var.vm_name}/${var.vm_name}.json"
    strip_path = true
  }

}

####### Variaveis bloco #########

variable "vm_name" {}

variable "headless" {}

variable "username" {}

variable "password" {}

variable "ssh_port" {}

variable "output_vbox" {}

variable "domain" {}

variable "hostname" {}

variable "disk_size" {}

variable "image_format" {}

variable "check_sum_16" {}

variable "ubuntu_16" {}

variable "check_sum_18" {}

variable "ubuntu_18" {}

variable  "ubuntu_20" {}

variable "check_sum_20" {}

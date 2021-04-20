packer {
  required_version = ">= 1.6.5"
}
################      Source bloco       ################
source "virtualbox-iso" "linux" {
  boot_command          = ["<enter><wait><f6><esc><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
            "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
            "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
            "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
            "/install/vmlinuz<wait>",
            " auto<wait>",
            " console-setup/ask_detect=false<wait>",
            " console-setup/layoutcode=us<wait>",
            " console-setup/modelcode=pc105<wait>",
            " debconf/frontend=noninteractive<wait>",
            " debian-installer=en_US<wait>",
            " fb=false<wait>",
            " initrd=/install/initrd.gz<wait>",
            " kbd-chooser/method=us<wait>",
            " keyboard-configuration/layout=USA<wait>",
            " keyboard-configuration/variant=USA<wait>",
            " locale=en_US<wait>",
            " netcfg/get_domain=${var.domain}}<wait>",
            " netcfg/get_hostname=${var.hostname}<wait>",
            " grub-installer/bootdev=/dev/sda<wait>",
            " noapic<wait>",
            " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
            " -- <wait>",
            "<enter><wait>"]
  boot_wait               = "10s"
  disk_size               = "${var.disk_size}"
  guest_additions_path    = "VBoxGuestAdditions_{{.Version}}.iso"
  guest_os_type           = "Ubuntu_64"
  headless                = "${var.headless}"
  http_directory          = "http"
  iso_url                 = "${var.ubuntu_16}"
  iso_checksum            = "${var.check_sum_16}"
  keep_registered         = true
  disable_shutdown        = true
  shutdown_command        = "echo 'vagrant'|sudo -S shutdown -P now"
  vm_name                 = "${var.vmname}"
  ssh_username            = "${var.username}"
  ssh_password            = "${var.password}"
  ssh_port                = "${var.ssh_port}"
  ssh_wait_timeout        = "60m"
  virtualbox_version_file = ".vbox_version"
  output_directory        = "${var.output_vbox}/${var.vmname}"
}

source "virtualbox-ovf" "linux" {
  format           = "ova"
  keep_registered  = true
  shutdown_command = "echo 'vagrant'|sudo -S shutdown -P now"
  source_path      = "${var.output_vbox}/${var.vmname}/${var.vmname}.ova"
  ssh_password     = "vagrant"
  ssh_username     = "vagrant"
  vboxmanage       = [["modifyvm", "${var.vmname}", "--acpi", "on"]]
}

build {
  sources = [
              "source.virtualbox-iso.linux",
              "source.virtualbox-ovf.linux"
  ]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    only            = ["virtualbox-iso.linux"]
    script          = "scripts/setup.sh"
  }

  post-processor "manifest" {
    output     = "${var.output_vbox}/${var.vmname}/${var.vmname}.json"
    strip_path = true
  }

}

####### Variaveis bloco #########

variable "vmname" {}

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

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

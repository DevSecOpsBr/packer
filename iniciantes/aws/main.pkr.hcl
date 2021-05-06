# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

######## Builder Block ########
source "amazon-ebs" "ubuntu" {
  region                      = "${var.aws_region}"
  instance_type               = "${var.instance_type}"
  ami_name                    = "${var.ami_name}-${var.environment}-${local.timestamp}"
  ami_description             = "${var.ami_description}"
  ssh_username                = "${var.aws_username}"
  shutdown_behavior           = "terminate"
  force_delete_snapshot       = true
  ######## Search for Ubuntu 20.10 official image ########
  source_ami_filter           {
    filters = {
        virtualization-type = "hvm"
        name = var.base_ami
        root-device-type = "ebs"
    }
    owners = ["099720109477"]
    most_recent = true
  }

  ######## Tags Block ########
  tags = {
      Managed_by    = "Packer"
      Environment   = var.environment
      OS_Version    = "Ubuntu 20.10"
      Release       = "Latest"
      Cost_center   = "DevOps"
      template      = "DevOps Team"
  }

  ######## Device Block ########
  launch_block_device_mappings {
      encrypted     = true
      device_name   = "${var.device_name}"
      volume_size   = "${var.volume_size}"
  }

}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  ######## Provisioners Block ########
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install pyhton3",
      "pip3 install ansible",
      "sudo apt-get clean"
    ]
  }

  ######## Processors Block ########
  post-processor "manifest" {
    output     = "${var.output_dir}/${var.ami_name}-${var.environment}-${local.timestamp}-manifest.json"
    strip_path = true
  }

}

########### Variables Block ###############

variable "aws_region" {}

variable "aws_username" {}

variable "environment" {}

variable "base_ami" {}

variable "ami_name" {}

variable "ami_description" {}

variable "instance_type" {}

variable "device_name" {}

variable "volume_size" {}

variable "aws_app_tag" {}

variable "output_dir" {}

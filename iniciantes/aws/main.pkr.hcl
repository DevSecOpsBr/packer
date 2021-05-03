# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "ubuntu" {
  region                      = "${var.aws_region}"
  vpc_id                      = "${var.aws_vpcid}"
  subnet_id                   = "${var.aws_subnetid}"
  source_ami                  = "${var.base_ami}"
  instance_type               = "${var.instance_type}"
  ami_name                    = "${var.ami_name}-${var.environment}-${local.timestamp}"
  ami_description             = "${var.ami_description}"
  ssh_username                = "${var.aws_username}"
  shutdown_behavior           = "terminate"
  force_delete_snapshot       = true
  
  tags = {
      Managed_by    = "Packer"
      OS_Version    = "Ubuntu"
      Release       = "Latest"
      Base_AMI_Name = "{{ .SourceAMIName }}"
  }

  launch_block_device_mappings {
      device_name   = "/dev/sda1"
      encrypted     = true
      volume_size   = "${var.volume_size}"
  }

}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y cloud-guest-utils",
      "sudo apt-get clean"
    ]
  }

  post-processor "manifest" {
    output     = "${var.output_dir}/${var.ami_name}-${var.environment}-${local.timestamp}-manifest.json"
    strip_path = true
  }

}

########### Variables block ###############

variable "aws_app_tag" {}

variable "aws_region" {}

variable "aws_sg" {}

variable "aws_subnetid" {}

variable "aws_username" {}

variable "aws_vpcid" {}

variable "base_ami" {}

variable "environment" {}

variable "ami_name" {}

variable "ami_description" {}

variable "instance_type" {}

variable "volume_size" {}

variable "output_dir" {}

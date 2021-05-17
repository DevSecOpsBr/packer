aws_region = "eu-west-3"

aws_username = "ubuntu"

base_ami = "ubuntu/images/hvm-ssd/ubuntu-groovy-20.10-amd64-server-*"

environment = "dev"

ami_name = "ubuntu"

ami_description = "Created and Managed by Packer."

instance_type = "t3.medium"

device_name = "/dev/sda1"

volume_size   = 30

output_dir  = "output/manifests"

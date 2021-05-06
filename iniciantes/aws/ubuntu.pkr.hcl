aws_region = "eu-west-3"

aws_username = "ubuntu"

base_ami = "ubuntu/images/hvm-ssd/ubuntu-groovy-20.10-amd64-server-*"

environment = "dev"

ami_name = "ubuntu"

ami_description = "Ubuntu 20.10 Groovy created by Packer."

instance_type = "t2.micro"

volume_size   = 30

aws_app_tag = "webserver"

output_dir  = "output/manifests"

# What is Packer?

INFRASTRUCTURE AS CODE
Modern, Automated Packer is easy to use and automates the creation of any type of machine image. It embraces modern configuration management by encouraging you to use automated scripts to install and configure the software within your Packer-made images. Packer brings machine images into the modern age, unlocking untapped potential and opening new opportunities.

![Alt text](image/packer.jpeg?raw=true "Packer Hashicorp")

## Packer Example - Ubuntu 16.04

**Current Ubuntu Version Used**: 16.04.03

This example build configuration installs and configures Ubuntu 16.04 x86_64 minimal using Ansible, and then generates two Vagrant box files, for:

- AWS
- VirtualBox
- VMware
- VMware vSphere (template)

The example can be modified to use more Ansible roles, plays, and included playbooks to fully configure (or partially) configure a box file suitable for deployment for development environments.

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:

- [Packer](http://www.packer.io/)
- [Vagrant](http://vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/) (if you want to build the VirtualBox box)
- [VMware Fusion](http://www.vmware.com/products/fusion/) (or Workstation - if you want to build the VMware box)
- [Ansible](http://docs.ansible.com/intro_installation.html)
- [Portainer](https://portainer.io/install.html) (if you want manager your cluster via web browser)

## Usage

Make sure that all the required software (listed above) is installed, then cd to the directory containing this README.md file, and run:

    $ packer build -var 'vmname=ubuntu-template' -var-file=variables.json -only=virtualbox-iso local.json 
        or 
    $ packer build -var 'vmname=ubuntu-template' -var-file=variables.json -only=vmware-iso local.json
        or
    $ packer build -var 'vmname=ubuntu-template' -var 'playbook=<name>' -var-file=variables.json aws.json

After a few minutes, Packer should tell you the box was generated successfully.

If you want to only build a box for one of the supported virtualization platforms (e.g. only build the VMware box), add `--only=vmware-iso` to the `packer build` command:

## Testing built boxes

There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From this same directory, run one of the following commands after building the boxes:

    # For VMware Fusion:
    $ vagrant up vmware --provider=vmware_fusion
    
    # For VirtualBox:
    $ vagrant up virtualbox --provider=virtualbox

## License

MIT license.

## Author Information

Author: Rodrigo Carvalho

Skype: rdgacarvalho

DevSecOps & IT Architect

Created in 2017

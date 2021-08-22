terraform {
  required_providers {
    aws = {
	  source  = "hashicorp/aws"
	  version = "~> 3.27"
	}
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}

module "instance_vm_sg" {
    source = "terraform-aws-modules/security-group/aws"
	name        = "${var.project-name}-${var.env}-instance-sg"
	description = "Security group for ec2-instance"
	vpc-id      = "${vpc_id}"
	ingress_with_cidr_blocks = [
	  {
	    from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		description = "SSH Access"
		cidr_blocks = "0.0.0.0/0"
	  }
	]
	egress_with_cidr_blocks = [
	  {
	    from_port   = 0
		to_port     = 0
		protocol    = "-1"
		description = "All Access"
		cidr_blocks = "0.0.0.0/0"
	  }
	]
}

data "aws_subnet_ids" "all" {
  vpc_id = var.vpc_id
}

module "instance_vm" {
    source = "terraform-aws-modules/ec2-instance/aws"
	version= "~> 2.0"
	
	name           = "${var.project-name}-${var.env}-instance"
	key_name       = "${var.instance_key}"
	ami            = "${var.ec2_ami_id}"
    instance_type  = "${var.instance_type}"
   	subnet_id      = tolist[data.aws_subnet_ids.all.ids][0]
	vpc_security_group_id = [module.instance_vm_sg.security_group_id]
	
	tags = {
	  terraform    = "true"
	  project-name = "${var.project-name}"
	  environment  = "${var.env}"
	  resource     = "ec2-instance-with docker"
	}
}

resource "aws_ebs_volume" "this" {
  availability_zone = module.instance_vm.availability_zone
  size              = var.ebs_vol_size
  tags = {
    terraform    = "true"
    project-name = "${var.project-name}"
    environment  = "${var.env}"
    resource     = "ec2-instance-ebs"
  }
}

resource "aws_volume_attachment" "this" {

  device_name = "${var.ebs_block_device_name}"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.instance_vm.id
}

resource "null_resource" "docker_install" {
	connection {
		type        = "ssh"
		user        = "ec2-user"
		private_key = file(/home/ubuntu/instance_key.pem)
		host        = module.instance_vm.private_ip
	}
	provisioner "remote-exec" { 
		inline = [
		    sudo yum update -y
            sudo amazon-linux-extras install docker -y
            sudo service docker start
	        docker login --username="someuser" --password="asdfasdf" --email="https://example.com/v1/"
            sudo usermod -a -G docker ec2-user
		]
	}
  depends_on = ["module.instance_vm"]
}

resource "null_resource" "copy_file" {

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.access_key_location} ec2-user@${module.instance_vm.private_ip}:~/.docker/daemon.json ."
  }

  depends_on = ["null_resource.docker_install"]
}
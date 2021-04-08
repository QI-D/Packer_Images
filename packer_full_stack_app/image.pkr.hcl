locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
}

source "amazon-ebs" "example" {
  ami_name      = "packer nginx ${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-west-2"

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  ssh_username = "ec2-user"
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "file" {
    source      = "./mongodb-org-4.4.repo"
    destination = "/tmp/mongodb-org-4.4.repo"
  }

  provisioner "file" {
    source      = "./app.env"
    destination = "/tmp/app.env"
  }

  provisioner "file" {
    source      = "./ImageApp.service"
    destination = "/tmp/ImageApp.service"
  }

  provisioner "file" {
    source      = "./nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "shell" {
    script = "./setup.sh"
  }
}
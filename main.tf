# DEFINIÇÃO DO PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# DEFINIÇÃO DA REGIÃO 
provider "aws" {
  region     = "us-east-1"
}

# SECURITY GROUP PARA INSTANCIA
resource "aws_security_group" "checkpoint2" {
  name = "checkpoint2"
  description = "SG para checkpoint2"
  vpc_id = "vpc-020ac3b37a95f6843"

# A regra a seguir libera saída para qualquer destino em qualquer protocolo
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
      from_port       = "0"
      to_port         = "0"
      protocol        = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
  }


}

# provisioner
resource "aws_instance" "checkpoint2" {
    ami = "ami-042e8287309f5df03"
    instance_type = "t2.micro"
    subnet_id = "subnet-02864174aef349b1d"
    key_name = "minhachavepub"
    
    provisioner "remote-exec" {
        inline = [ 
            "sudo apt-get update",
            "sudo apt-get -y install nginx",
            "sudo systemctl start nginx"
        ]

    #provisioner "file" {
    #   source = "index.html"
    #   destination = "/tmp/index.html"

        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file("~/.ssh/id_rsa")
            host = self.public_ip

        }
      
    }
}

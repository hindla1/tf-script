resource "aws_key_pair" "mykey" {

     key_name = "my-own-key"
     public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrTIWNdQIGkZuiym5L+l4ZJ6OPQkvUsJltFRIqqRJ7O+f7Uzl9xOo9viX6tJ2ebajIODd5cnEmtUYvOxz7fjk44hL5ptfZCWX0Wx/V5+4bOMToEmpXQrZiIpaxlKHcZzUEAkgMCRH/LhhCHsUOyiH3ogYBs9uZkF294dEhaj5iM0TJ5sLEn0wzMISdFjAe37492J7NLNyx/N7c5hwO2Xj2677RbZS+85ZLILfTVwkfphwHt9aubmQ/amlqaKLoBTqDSGvZynIDQPbUAz4dOlWNDYVVfCYZIeSps59NwF255HkKseaN6eEZmK+aWQaUy5Qs8rfPODCqmp2tCzjJrDyEnM3gAACDKvTngio6CnE6St2Ieb1TPbLARgPKF8C12s5wOPtOjWN5GtlBlAOqWsqucQIlz7XlDVYbwM7vgm/HQcJoiSbnTc+/9yFZZwv2gBBIpPaV9bPYWyqcqrqTVcdoQyjxTxAuPHp/g4Q22XUns2x9HBNIQfpIZueyOi/vHCk= i353111@FVFVT124J1WV" 

}


resource "aws_instance" "sample" {
  #  ami = "ami-0a54aef4ef3b5f881"
  ami           = "${var.AMI}"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  #   count = 5
  #  availability_zone = ""
  key_name = "my-own-key"
  security_groups = [ "${aws_security_group.my-own-sg.name}" ]

  
  tags =  {
    Name = "app-server"
  }

root_block_device {
   
   volume_size = 20
   volume_type = "gp2"
   delete_on_termination = true

}


/*    
  provisioner "local-exec" {
      command = "echo ${aws_instance.sample.public_ip} > ip_address.txt"
  }
 provisioner "remote-exec" {
    inline = [
       "sudo yum install httpd -y",
       "sudo systemctl start httpd",
       "sudo chmod -R 777 /var"
       ]
   }

connection {
   host = self.public_ip
   type = "ssh"
   user = "ec2-user"
   private_key = file("my-tf-key")
}

  provisioner "file"  {
     source = "index.html"
     destination = "/var/www/html/index.html"
 }
*/

 # depends_on = [aws_s3_bucket.my-bucket]
}

resource "aws_security_group" "my-own-sg" {

    name = "allow-ssh"
    description = "this will allow ssh connections to my ec2 machine from outside world"
   

   ingress {    ###inbound rules
   
     from_port = 22 
     to_port =  22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]

     }

 ingress {    ###inbound rules

     from_port = 80
     to_port =  80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]

     }
   
   egress {     ###outbound rules
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }

}




resource "aws_ebs_volume" "my-own-ebs" {

   type = "gp2"
   size = "500"
   availability_zone = "us-east-2a"

  tags = {
    Name = "extra_volume"
   } 

}


resource "aws_volume_attachment" "my-attachment" {

    device_name = "/dev/xvdh"
    volume_id  = "${aws_ebs_volume.my-own-ebs.id}"
    instance_id =  "${aws_instance.sample.id}"

}



/*
resource "aws_s3_bucket" "my-bucket" {

  bucket = "hindla001"
  acl    = "public-read"
  versioning {
    enabled = true
  }
}
*/

/*
resource "aws_eip" "my-pub" {

  instance = "${aws_instance.sample.id}"
  vpc      = true
}
*/





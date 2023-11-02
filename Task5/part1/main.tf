#################################################################
# Terraform file for EC2 Instances creations 
# AWS Secret Credentials are masked
#################################################################

# Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}

# provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity-T2" {
  count = 4
  ami = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
  subnet_id = "subnet-0a1081e99341f585f"
  tags = {
    Name = "Udacity T2"
  }
}

# provision 2 m4.large EC2 instances named Udacity M4
#resource "aws_instance" "Udacity-M4" {
#  count = 2
#  ami = "ami-0742b4e673072066f"
#  instance_type = "m4.large"
#  subnet_id = "subnet-0a1081e99341f585f"
#  tags = {
#    Name = "Udacity M4"
#  }
#}

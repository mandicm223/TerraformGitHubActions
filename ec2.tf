
resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "bastion_key_pair" {
  key_name   = "bastion-key-test"
  public_key = tls_private_key.bastion.public_key_openssh
}
resource "aws_ssm_parameter" "bastion_key_pair" {
  #   name  = format("%s/bastion/ssh-key", var.environments[terraform.workspace])
  name  = "/test/bastion/ssh-key"
  type  = "SecureString"
  value = tls_private_key.bastion.private_key_pem
}
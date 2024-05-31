# Create the main EC2 instance
# https://www.terraform.io/docs/providers/aws/r/instance.html


# Attach the separate data volume to the instance, if so configured

resource "aws_volume_attachment" "this" {
  count       = "${var.data_volume_id == "" ? 0 : 1}" # only create this resource if an external EBS data volume was provided
  device_name = "/dev/xvdh"                           # note: this depends on the AMI, and can't be arbitrarily changed
  instance_id = "${aws_instance.this.id}"
  volume_id   = "${var.data_volume_id}"
}

resource "null_resource" "provisioners" {
  count      = "${var.data_volume_id == "" ? 0 : 1}" # only create this resource if an external EBS data volume was provided
  depends_on = ["aws_volume_attachment.this"]        # because we depend on the EBS volume being available

  connection {
    host        = "${aws_instance.this.public_ip}"
    user        = "${var.ssh_username}"
    private_key = "${file("${var.ssh_private_key_path}")}"
    agent       = false                                    # don't use SSH agent because we have the private key right here
  }

  # When creating the attachment
  provisioner "remote-exec" {
    script = "${path.module}/provision-ebs.sh"
  }

  # When tearing down the attachment
  provisioner "remote-exec" {
    when   = "destroy"
    inline = ["sudo umount -v ${aws_volume_attachment.this.device_name}"]
  }
}

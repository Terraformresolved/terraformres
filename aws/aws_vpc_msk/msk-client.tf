resource "aws_iam_instance_profile" "KafkaClientIAM_Profile" {
  name = "KafkaClientIAM_profile"
  role = aws_iam_role.KafkaClientIAM_Role.name
}

resource "aws_iam_role" "KafkaClientIAM_Role" {
  name = "KafkaClientIAM_Role"
  path = "/"


  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "Kafka-Client-IAM-role-att1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonMSKFullAccess"
  role       = aws_iam_role.KafkaClientIAM_Role.name
}

resource "aws_iam_role_policy_attachment" "Kafka-Client-IAM-role-att2" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess"
  role       = aws_iam_role.KafkaClientIAM_Role.name
}



output "IP" {
  value       = aws_instance.Kafka-Client-EC2-Instance.private_ip
  description = "The private IP address of the Kafka-Client-EC2-Instance instance."
}

module "acm_alb" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> v2.0"
  domain_name = var.public_alb_domain
  zone_id     = data.aws_route53_zone.this.zone_id
  tags        = var.tags
}

resource "aws_security_group" "alb" {
  name        = "${var.prefix}-alb-${var.environment}"
  description = "Allow HTTPS inbound traffc"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  tags = var.tags
}


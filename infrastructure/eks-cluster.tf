#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "s4s-cluster" {
  name = "terraform-eks-s4s-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "s4s-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.s4s-cluster.name
}

resource "aws_iam_role_policy_attachment" "s4s-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.s4s-cluster.name
}

resource "aws_security_group" "s4s-cluster" {
  name        = "terraform-eks-s4s-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.s4s.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-s4s"
  }
}

resource "aws_security_group_rule" "s4s-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.s4s-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "s4s" {
  name     = var.cluster-name
  role_arn = aws_iam_role.s4s-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.s4s-cluster.id]
    subnet_ids         = aws_subnet.s4s[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.s4s-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.s4s-cluster-AmazonEKSVPCResourceController,
  ]
}

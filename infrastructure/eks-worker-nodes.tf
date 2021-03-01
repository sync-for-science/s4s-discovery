#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "s4s-node" {
  name = "terraform-eks-s4s-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "s4s-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.s4s-node.name
}

resource "aws_iam_role_policy_attachment" "s4s-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.s4s-node.name
}

resource "aws_iam_role_policy_attachment" "s4s-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.s4s-node.name
}

resource "aws_eks_node_group" "s4s" {
  cluster_name    = aws_eks_cluster.s4s.name
  node_group_name = "s4s"
  node_role_arn   = aws_iam_role.s4s-node.arn
  subnet_ids      = aws_subnet.s4s[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.s4s-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.s4s-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.s4s-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  subnet_ids      = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  eks_managed_node_group_default = {
    root_volume_type = "gp2"
  }

  eks_managed_node_groups = {
    one = {
      name                          = "node-group-1"
      instance_types                = "t2.small"
      desired_size                  = 2
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

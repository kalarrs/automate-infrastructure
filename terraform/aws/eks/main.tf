locals {
  stage = lookup(var.tags, "Stage", "")
}

module "eks" {
  source  = "registry.terraform.io/terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "${var.name}-${local.stage}"
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni    = {
      resolve_conflicts = "OVERWRITE"
    }
  }

#  cluster_encryption_config = [
#    {
#      provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
#      resources        = ["secrets"]
#    }
#  ]

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "m6i.large"
    update_launch_template_default_version = true
    iam_role_additional_policies           = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  self_managed_node_groups = {
    one = {
      name         = "mixed-1"
      max_size     = 5
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy     = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "m5.large"
            weighted_capacity = "1"
          },
          {
            instance_type     = "m6i.large"
            weighted_capacity = "2"
          },
        ]
      }
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue  = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # Fargate Profile(s)
#  fargate_profiles = {
#    default = {
#      name      = "default"
#      selectors = [
#        {
#          namespace = "default"
#        }
#      ]
#    }
#  }

  tags = var.tags
}

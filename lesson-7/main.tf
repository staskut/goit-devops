# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source = "./modules/s3-backend"                # Шлях до модуля
  bucket_name = "kut-terraform-state-bucket-001001"  # Ім'я S3-бакета
  table_name  = "terraform-locks"                # Ім'я DynamoDB
}

provider "aws" {
  profile = "personal"  # <- замініть на потрібний профіль
  region  = "eu-west-2"                 # <- або ваш бажаний регіон

  default_tags {
      tags = var.tags
  }
}

# Call VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block 
  public_subnets     = var.public_subnets_cidrs
  private_subnets    = var.private_subnets_cidrs
  availability_zones = var.availability_zones
  vpc_name           = "lesson-8-9-vpc"
}


# Call ECR
module "ecr" {
    source          = "./modules/ecr"
    ecr_name        = "lesson-8-9-ecr"
    force_delete    = true
}


# Call EKS module
module "eks" {
  source                     = "./modules/eks"
  cluster_name               = var.cluster_name
  cluster_version            = "1.31"

  vpc_id                     = module.vpc.vpc_id
  public_subnets             = module.vpc.public_subnets
  private_subnets            = module.vpc.private_subnets

  tags                       = var.tags
}



# IAM role for EBS CSI driver
module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "AmazonEKS_EBS_CSI_Driver"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

# EBS CSI driver add-on
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                       = module.eks.cluster_name
  addon_name                         = "aws-ebs-csi-driver"
  resolve_conflicts_on_create        = "OVERWRITE"
  service_account_role_arn           = module.ebs_csi_driver_irsa.iam_role_arn

  depends_on = [
    module.eks,
    module.ebs_csi_driver_irsa
  ]
}


# Jenkins

data "aws_eks_cluster" "eks" {
  name = var.cluster_name

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name

  depends_on = [module.eks]
}

# if need import oidc_provider_arn
# data "aws_iam_openid_connect_provider" "oidc" {
#   url = module.eks.oidc_provider_url
# }

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}


provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}


data "aws_caller_identity" "current" {}


module "jenkins" {
  source            = "./modules/jenkins"
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  # oidc_provider_arn = data.aws_iam_openid_connect_provider.oidc.arn
  oidc_provider_url = module.eks.oidc_provider_url
  github_pat        = var.github_pat
  github_user       = var.github_user
  github_repo_url   = var.github_repo_url

  # jenkins_sa_name   = kubernetes_service_account.jenkins_sa.metadata.0.name
  jenkins_sa_name   = module.jenkins.jenkins_sa_name

  depends_on        = [module.eks]

  providers         = {
    helm       = helm
    kubernetes = kubernetes
  }
}


module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "5.46.4"
  depends_on    = [module.eks]
}

module "rds" {
  source = "./modules/rds"

  name                       = "goit-devops-db"
  use_aurora                 = true
  aurora_instance_count      = 2

  # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "admin123AWS23"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = false
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}

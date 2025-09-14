# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source = "./modules/s3-backend"                # Шлях до модуля
  bucket_name = "kut-terraform-state-bucket-001001"  # Ім'я S3-бакета
  table_name  = "terraform-locks"                # Ім'я DynamoDB
}

provider "aws" {
  profile = "personal"  # <- замініть на потрібний профіль
  region  = "eu-west-2"                 # <- або ваш бажаний регіон
}

# Підключаємо модуль для VPC
module "vpc" {
  source              = "./modules/vpc"           # Шлях до модуля VPC
  vpc_cidr_block      = "10.0.0.0/16"             # CIDR блок для VPC
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]        # Публічні підмережі
  private_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]         # Приватні підмережі
  availability_zones  = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]            # Зони доступності
  vpc_name            = "vpc"              # Ім'я VPC
}

module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-5-ecr"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "eks-cluster-demo"            # Назва кластера
  subnet_ids      = module.vpc.public_subnets     # ID підмереж
  instance_type   = "t3.medium"                    # Тип інстансів
  desired_size    = 1                             # Бажана кількість нодів
  max_size        = 2                             # Максимальна кількість нодів
  min_size        = 1                             # Мінімальна кількість нодів
}

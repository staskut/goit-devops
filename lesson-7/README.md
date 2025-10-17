# Project usage

This project deploys an s3, VPC(with subnets), EKS, ECR cluster using Terraform. You need an AWS account and configured credentials to use it.

1. Clone the repository:
   git clone <repo-url>
   cd <repo-directory>

2. Initialize Terraform:
   terraform init

3. Preview the infrastructure plan:
   terraform plan

4. Apply the configuration:
   terraform apply

## Backend

The remote backend is initially commented. After the first terraform apply:
Uncomment the backend block in root.
Run:
terraform init

Now you have terraform state in remotely stored in s3 bucket.

!notice make sure in terraform output you have oidc_provider_arn
if not, try creating IF by steps

# Step 2

Update kubectl credentials:
aws eks update-kubeconfig --name <cluster-name> --region <region>

To lists all services in the namespace you specify:
 kubectl get svc -n <your-namecpace>


to get password for argocd:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

## *Helm charts

Charts are there, but if needed use commands:
helm dependency update charts/django-app
helm upgrade --install django-app charts/django-app



## Jenkins:
 first got to UI, approve seed job
 then build now -> it will create goit-django-docker 
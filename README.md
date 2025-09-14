# Django on Kubernetes with Helm & ECR

This project demonstrates how to deploy a Django web application using **Kubernetes**, **Helm**, **AWS ECR**, and **PostgreSQL**.

---

## Stack

* Python 3.10
* Django 5.2
* PostgreSQL 14
* Docker
* Kubernetes (EKS)
* Helm
* AWS Elastic Container Registry (ECR)
* Nginx (optional)

---

##  Deployment Overview

### 1. Docker Image

Django app is packaged into a Docker image.

**Build locally:**

```bash
docker build -t lesson-5-ecr:v4 ./django
```

**Tag & Push to ECR:**

```bash
docker tag lesson-5-ecr:v4 865683084473.dkr.ecr.eu-west-2.amazonaws.com/lesson-5-ecr:v4
docker push 865683084473.dkr.ecr.eu-west-2.amazonaws.com/lesson-5-ecr:v4
```
![img.png](img.png)
---

### 2. Kubernetes via Helm

This project uses a Helm chart located in `./django-app/`.

#### Values configured via `values.yaml`:

```yaml
replicaCount: 2

image:
  repository: 865683084473.dkr.ecr.eu-west-2.amazonaws.com/lesson-5-ecr
  tag: v4

env:
  DEBUG: "False"
  SECRET_KEY: "changeme123"
  ALLOWED_HOSTS: "your-loadbalancer-url.com"
  POSTGRES_HOST: "postgres"
  POSTGRES_PORT: "5432"
  POSTGRES_NAME: "mydb"
  POSTGRES_USER: "myuser"
  POSTGRES_PASSWORD: "mypassword"
```

#### Install or upgrade:

```bash
helm upgrade --install django ./django-app
```

#### Expose via LoadBalancer:

Service is exposed on port `80` using `type: LoadBalancer`. Access the app via:

```text
http://<your-load-balancer-dns>
```

You can find the DNS name in the output of the `kubectl get svc` command.

![img_1.png](img_1.png)
![img_2.png](img_2.png)
![img_3.png](img_3.png)
![img_4.png](img_4.png)
---

## PostgreSQL Setup

A separate deployment for Postgres is included (can be YAML or another chart). It creates a persistent volume and exposes the DB internally in the cluster.

Connection settings for Django are passed via `ConfigMap`.

---

## Run Migrations

After the pod is running, you can run migrations manually:

```bash
kubectl exec -it <django-pod> -- python manage.py migrate
```

---

## Testing

You should be able to access `/admin` endpoint.

Ensure the main route `/` is configured in `urls.py`:

```python
from django.http import HttpResponse

def home(request):
    return HttpResponse("✅ Hello from Django on Kubernetes!")

urlpatterns = [
    path('', home),
]
```

Then access:

```text
http://<loadbalancer-dns>/
```

---

## Project Structure

```
.
├── django/
│   ├── manage.py
│   ├── goit/
│   │   └── settings.py
│   └── Dockerfile
├── django-app/         # Helm chart
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── templates/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── configmap.yaml
├── postgres.yaml       # (Optional) PostgreSQL K8s manifest
└── README.md
```

---

## Notes

* Keep `SECRET_KEY` secret in production.
* Set `DEBUG: "False"` and define strict `ALLOWED_HOSTS`.

---

## Useful Commands

```bash
# Get pod logs
kubectl logs <pod-name>

# Check all services
kubectl get svc

# Run command inside Django pod
kubectl exec -it <pod-name> -- bash
```

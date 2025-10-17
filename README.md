# CI/CD Infrastructure with Terraform, Jenkins & Argo CD

## 1. Застосування Terraform

### Попередні вимоги

* Встановлений **Terraform**
* AWS CLI налаштований з правами доступу
* Helm встановлений локально

### Команди для запуску інфраструктури

1. Ініціалізація Terraform:

   ```bash
   terraform init
   ```

2. Перевірка змін:

   ```bash
   terraform plan
   ```

3. Застосування конфігурацій:

   ```bash
   terraform apply
   ```

   Після виконання:

   * Створюється EKS кластер.
   * Деплоїться Jenkins (через Helm).
   * Створюється service account та IAM роль для Kaniko.
   * Argo CD розгортається для деплою застосунку.

4. Перевірити, що Jenkins та ArgoCD запущені:

   ```bash
   kubectl get pods -n jenkins
   kubectl get pods -n argocd
   ```

5. Отримати зовнішні URL:

   ```bash
   kubectl get svc -n jenkins
   kubectl get svc -n argocd
   ```

---

## 2. Перевірка Jenkins job

### Вхід у Jenkins

1. Відкрити LoadBalancer URL Jenkins:

   ```
   http://<jenkins-external-dns>
   ```
2. Увійти під обліковими даними:

   * **Username:** `admin`
   * **Password:** `admin123`

### Seed Job

* При розгортанні Terraform автоматично створюється **seed-job**.
* Вона генерує основну pipeline job: **`goit-django-docker`**.

### Запуск збірки

1. Відкрити **goit-django-docker** → **Build Now**.
2. У логах має відображатися:

   * Клонування репозиторію GitHub
   * Kaniko build контейнера
   * Завантаження образу в **Amazon ECR**
![img.png](img.png)
![img_1.png](img_1.png)
![img_2.png](img_2.png)

### Перевірка успіху

* Якщо job завершується статусом **SUCCESS**, новий Docker-образ з’являється в ECR:

  ```bash
  aws ecr describe-images --repository-name <repo-name>
  ```

![img_3.png](img_3.png)
---

## 3. Перегляд результату в Argo CD

### Доступ до Argo CD

1. Отримати URL:

   ```bash
   kubectl get svc -n argocd
   ```

   Приклад:

   ```
   argocd-server   LoadBalancer   <EXTERNAL-IP>   80:30080/TCP   20m
   ```
2. Відкрити у браузері:

   ```
   http://<EXTERNAL-IP>
   ```
3. Увійти в ArgoCD (логін/пароль виводиться після деплою):

   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
   ```

### Перевірка деплою застосунку

1. Відкрити застосунок **django-app** у ArgoCD UI.
2. Якщо все коректно:

   * Статус: `Healthy` ✅
   * Sync status: `Synced` ✅
3. При натисканні на поди (наприклад, `django-app-postgresql-0` або `django-app-web`) видно активний деплой.

![img_5.png](img_5.png)
---

## Знищення інфраструктури

Для повного очищення:

```bash
terraform destroy
```

Якщо кластер вже видалено, але Terraform все ще має стейт:

```bash
terraform state rm <resource-name>
```

---

## Підсумок

* **Terraform** створює кластер, Jenkins, ArgoCD та IAM ресурси.
* **Jenkins** збирає Docker-образ з Kaniko та пушить в ECR.
* **Argo CD** автоматично синхронізує деплой з останнім образом у GitHub.

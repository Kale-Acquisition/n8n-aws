# 🧠 n8n Setup on AWS (Fargate + RDS) using AWS Copilot

This repository contains the infrastructure and deployment configuration to run a scalable, persistent instance of [n8n](https://n8n.io) using:

- **AWS Copilot CLI** (Fargate, ALB, CloudWatch, VPC, etc.)
- **PostgreSQL** via Amazon RDS
- **Custom domain**
- **Autoscaling**
- **Persistent setup with no data loss on redeployments**

---

The application is live and accessible at:

**👉(https://n8n.kaleacquisition.com)**

## 🚀 Tech Stack

| Component       | Service                                     |
| --------------- | ------------------------------------------- |
| Workflow engine | `n8n` (Docker-based)                        |
| Hosting         | AWS ECS (Fargate via Copilot + Autoscaling) |
| DB              | PostgreSQL (Amazon RDS `t4g.small`)         |
| Load balancer   | ALB (Application Load Balancer)             |
| DNS/Domain      | External registrar                          |
| Monitoring      | Amazon CloudWatch (logs + alarms)           |
| Storage         | PostgreSQL handles persistence              |

---

Auto rolling updates with AWS Copilot if deployment fails.

## 🚀 CI/CD: Auto Deployment

GitHub Actions are configured to automatically trigger deployment whenever changes are pushed to the main branch.
You can also manually trigger the workflow from the Actions tab if needed.

## 🔧 Deployment Steps Locally (No need if CI/CD setted up)

Make sure first you have correctly configure AWS Credentials

```bash
aws configure
```

### 1. Install AWS Copilot CLI

```bash
brew install aws/tap/copilot-cli
```

### 2. Initialize Application & Service

```bash
copilot init
```

Follow prompts to name the app (e.g., kle-n8n), service (n8n), n8n.Dockerfile, and select Load Balanced Service for public access

### 3. Deploy to an Environment

```bash
copilot env init --name prod
copilot deploy
```

### 4. Setup PostgreSQL (RDS)

Go to AWS console -> Create RDS instance (t4g.small, 20GB)
Same VPC as Copilot app
Add security group to allow ECS task access
Create database: n8n
Create master user: n8n
Secrets Manager used for storing the database password

### 6. Add Environment Variables

Edit ( copilot/manifest.yml ) to add the variables and secrets.
Secrets are injected automatically during deployment.

### 7. Monitoring

AWS Cloudwatch for monitoring logs

Go to AWS Cloudwatch -> Log groups -> /copilot/kle-n8n-prod-n8n

Also we can monitor our service in AWS ECS -> Select Cluster -> Go to our Service (there is more detailed metrics to monitor)

### 8. Manual Redeployments

After initial deployment now just change manifest.yml file and run command

```bash
copilot deploy
```

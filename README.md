# 🏪 Sri Rajeswari Provisions - Complete DevOps Portfolio Project

![DevOps](https://img.shields.io/badge/DevOps-Complete%20Pipeline-blue)
![Microservices](https://img.shields.io/badge/Architecture-Microservices-green)
![Kubernetes](https://img.shields.io/badge/Platform-Kubernetes-orange)
![AWS](https://img.shields.io/badge/Cloud-AWS-yellow)

A production-ready, microservices-based inventory and sales management system for a provisions store, deployed on AWS EKS with full DevOps practices and modern cloud-native technologies.

## 📋 Project Overview

Sri Rajeswari Provisions is a complete DevOps demonstration project that showcases end-to-end implementation of modern software development practices. The application manages inventory, sales, customer relationships, payments, and notifications for a retail provisions store.

### 🎯 Business Features
- **Real-time Inventory Management** with automatic low-stock alerts
- **Sales Tracking & Analytics** with revenue monitoring
- **Customer Management** with notification system
- **Payment Processing** integration
- **Automated Reordering** suggestions
- **Dashboard & Reporting** for business insights

## 🏗️ Architecture

```mermaid
graph TB
    A[React Frontend] --> B[NGINX Ingress]
    B --> C[API Gateway]
    C --> D[Inventory Service]
    C --> E[Sales Service]
    C --> F[Customer Service]
    C --> G[Payment Service]
    C --> H[Notification Service]
    D --> I[(PostgreSQL)]
    E --> I
    F --> I
    G --> I
    
    J[Prometheus] --> K[Grafana]
    L[ELK Stack] --> M[Kibana]
    N[GitHub Actions] --> O[AWS ECR]
    O --> P[AWS EKS]
    P --> Q[Helm Charts]
🛠️ Technology Stack
🔧 Core Technologies
Frontend: React 18, Vite, Chart.js

Backend: Python FastAPI, SQLAlchemy

Database: PostgreSQL

Containerization: Docker

Orchestration: Kubernetes, Helm

Infrastructure: Terraform, AWS

☁️ Cloud & DevOps
Cloud Provider: AWS (EKS, ECR, RDS, VPC)

CI/CD: GitHub Actions, Docker

Monitoring: Prometheus, Grafana, ELK Stack

Security: SonarQube, Trivy

GitOps: ArgoCD

Service Mesh: Istio (Optional)

📁 Project Structure
text
sri-rajeswari-provisions/
├── 📁 .github/workflows/          # CI/CD Pipelines
├── 📁 infrastructure/             # Terraform Configs
├── 📁 microservices/              # Backend Services
│   ├── 📁 inventory-service/      # Product & Stock Management
│   ├── 📁 sales-service/          # Sales & Transactions
│   ├── 📁 customer-service/       # Customer Management
│   ├── 📁 payment-service/        # Payment Processing
│   └── 📁 notification-service/   # Email/SMS Alerts
├── 📁 frontend/                   # React Application
├── 📁 kubernetes/                 # K8s Manifests & Helm
├── 📁 monitoring/                 # Observability Stack
├── 📁 database/                   # Schema & Migrations
├── 📁 scripts/                    # Deployment Utilities
├── 🐳 docker-compose.yml          # Local Development
├── 📝 Makefile                    # Build Automation
└── 📚 README.md                   # Documentation
🚀 Quick Start
Prerequisites
Docker & Docker Compose

Python 3.9+

Node.js 18+

AWS CLI (for production)

kubectl & helm (for Kubernetes)

Local Development
bash
# Clone the repository
git clone https://github.com/yourusername/sri-rajeswari-provisions.git
cd sri-rajeswari-provisions

# Start all services locally
make deploy-local

# Or use docker-compose directly
docker-compose up -d
Access Local Services
Frontend: http://localhost:3000

Inventory API: http://localhost:8001

Sales API: http://localhost:8002

Customer API: http://localhost:8003

Payment API: http://localhost:8004

Notification API: http://localhost:8005

PostgreSQL: localhost:5432

🏗️ Infrastructure Setup
AWS Infrastructure with Terraform
bash
# Initialize Terraform
cd infrastructure
terraform init

# Plan infrastructure
terraform plan

# Deploy infrastructure
terraform apply -auto-approve
Kubernetes Deployment
bash
# Apply Kubernetes manifests
make k8s-deploy

# Or use kubectl directly
kubectl apply -f kubernetes/manifests/

# Verify deployment
kubectl get pods -n sri-rajeswari-provisions
🔄 CI/CD Pipeline
GitHub Actions Workflows
CI Pipeline: On every pull request

Code quality checks

Unit testing

Security scanning (Trivy)

SonarQube analysis

CD Pipeline: On main branch merge

Docker image building

ECR push

EKS deployment

Smoke tests

Manual Deployment
bash
# Build all services
make build

# Run tests
make test

# Deploy to production
make k8s-deploy
📊 Monitoring & Observability
Access Monitoring Stack
bash
# Port forward to access locally
kubectl port-forward -n monitoring svc/grafana 3000:3000
kubectl port-forward -n monitoring svc/prometheus 9090:9090
kubectl port-forward -n monitoring svc/kibana 5601:5601
Monitoring URLs
Grafana Dashboard: http://localhost:3000

Prometheus: http://localhost:9090

Kibana: http://localhost:5601

Key Metrics Monitored
Application performance (response times, error rates)

Business metrics (sales, inventory levels)

Infrastructure metrics (CPU, memory, disk)

Database performance

🗄️ Database Schema
Core Tables
products: Product catalog with pricing and stock levels

sales: Transaction records with timestamps

customers: Customer information and contact details

payments: Payment transaction records

inventory_logs: Stock change history

Sample Data
The application comes pre-loaded with sample products:

Rice & Grains: Basmati Rice, Wheat Atta

Oils: Sunflower Oil, Groundnut Oil

Pulses: Toor Dal, Chana Dal

Daily Needs: Sugar, Salt, Tea Powder

Beverages: Coca-Cola, Milk

Vegetables: Tomato, Potato, Onion

🔐 Security
Implemented Security Measures
Container Security: Non-root users in Docker

Network Security: VPC, Security Groups, Network Policies

Secrets Management: Kubernetes Secrets, AWS Secrets Manager

SAST: SonarQube code analysis

DAST: Trivy vulnerability scanning

TLS/SSL: HTTPS enforcement

Security Scanning
bash
# Run security scan
docker run --rm -v $(pwd):/src aquasec/trivy:latest fs /src

# Code quality scan
sonar-scanner
🧪 Testing
Test Structure
bash
# Run all tests
make test

# Run specific service tests
cd microservices/inventory-service
pytest tests/ -v

# Frontend tests
cd frontend
npm test
Test Coverage
Unit tests for all microservices

Integration tests for API endpoints

End-to-end tests for critical user journeys

Performance and load testing

📈 Performance & Scaling
Horizontal Pod Autoscaling
yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
Resource Limits
yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
🔧 Configuration Management
Environment Configuration
Development: docker-compose.yml

Staging: values-staging.yaml

Production: values-production.yaml

Feature Flags
A/B testing capabilities

Gradual feature rollouts

Emergency kill switches

🤝 API Documentation
Available Endpoints
Inventory Service: /products, /low-stock, /categories

Sales Service: /sales, /sales/today

Customer Service: /customers

Payment Service: /payments

OpenAPI Documentation
Each microservice provides automatic OpenAPI documentation at:

text
http://service-host:port/docs
🚨 Alerting & Notifications
Business Alerts
Low stock notifications

High-value sales alerts

Inventory discrepancy alerts

Payment failure notifications

Technical Alerts
Service downtime

High error rates

Resource utilization thresholds

Security incidents

📝 Development Guide
Adding New Features
Create feature branch from develop

Implement changes with tests

Update documentation

Create pull request

Code review and merge

Code Standards
Follow PEP 8 for Python

Use ESLint for JavaScript/React

Write comprehensive tests

Update API documentation

Include meaningful commit messages

🐛 Troubleshooting
Common Issues
bash
# Check service status
docker-compose ps
kubectl get pods -n sri-rajeswari-provisions

# View logs
docker-compose logs [service-name]
kubectl logs -n sri-rajeswari-provisions [pod-name]

# Database connectivity
psql -h localhost -U provisions_admin -d srirajeswariprovisions
Debug Commands
bash
# Kubernetes debugging
kubectl describe pod [pod-name]
kubectl get events --sort-by=.metadata.creationTimestamp

# Network debugging
kubectl run debug-pod --image=busybox --rm -it -- sh
📊 Business Metrics & Analytics
Key Performance Indicators
Daily Sales Revenue

Inventory Turnover Rate

Customer Acquisition Cost

Stockout Frequency

Average Transaction Value

Reporting Features
Real-time sales dashboard

Inventory valuation reports

Customer purchase history

Seasonal trend analysis

🌐 Production Deployment
AWS Services Used
EKS: Kubernetes cluster

ECR: Container registry

RDS: PostgreSQL database

VPC: Network isolation

ALB: Load balancing

CloudWatch: Logging and monitoring

Deployment Checklist
Infrastructure provisioned

Database migrations applied

SSL certificates configured

Monitoring stack deployed

Backup strategy implemented

Disaster recovery tested

🔄 Maintenance
Regular Tasks
Security patches updates

Database backups verification

Log rotation and cleanup

Performance optimization

Cost optimization reviews

Backup Strategy
bash
# Database backups
pg_dump srirajeswariprovisions > backup.sql

# Configuration backups
kubectl get all -n sri-rajeswari-provisions -o yaml > k8s-backup.yaml
🤝 Contributing
We welcome contributions! Please see our Contributing Guide for details.

Development Setup
Fork the repository

Create a feature branch

Make your changes

Add tests

Submit a pull request

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

🙏 Acknowledgments
FastAPI team for the excellent web framework

Kubernetes community for container orchestration

AWS for cloud infrastructure

React team for the frontend framework

📞 Support
For support, please open an issue in the GitHub repository or contact the maintainers.

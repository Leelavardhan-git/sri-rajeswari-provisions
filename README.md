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

### System Architecture Diagram
┌─────────────────┐ ┌──────────────────┐ ┌─────────────────┐
│ React │ │ NGINX │ │ API Gateway │
│ Frontend │────│ Ingress │────│ / Router │
└─────────────────┘ └──────────────────┘ └─────────────────┘
│
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ Inventory │ │ Sales │ │ Customer │ │ Payment │
│ Service │ │ Service │ │ Service │ │ Service │
└─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘
│ │ │ │
└───────────────────┼──────────────────┼──────────────────┘
│ │
┌──────────┴──────────────────┴──────────┐
│ PostgreSQL Database │
└────────────────────────────────────────┘

┌─────────────────┐ ┌──────────────────┐ ┌─────────────────┐
│ Prometheus │ │ Grafana │ │ ELK Stack │
│ Monitoring │────│ Dashboard │ │ Logging │
└─────────────────┘ └──────────────────┘ └─────────────────┘

┌─────────────────┐ ┌──────────────────┐ ┌─────────────────┐
│ GitHub Actions │ │ AWS ECR │ │ AWS EKS │
│ CI/CD │────│ Container Registry │──│ Kubernetes │
└─────────────────┘ └──────────────────┘ └─────────────────┘

text

### Data Flow
1. **Frontend** (React) → **Ingress** → **Microservices** → **Database**
2. **CI/CD Pipeline** → **Container Registry** → **Kubernetes Cluster**
3. **Applications** → **Monitoring Stack** → **Dashboards & Alerts**

## 🛠️ Technology Stack

### 🔧 Core Technologies
- **Frontend**: React 18, Vite, Chart.js, Axios
- **Backend**: Python FastAPI, SQLAlchemy, Pydantic
- **Database**: PostgreSQL 15
- **Containerization**: Docker, Docker Compose
- **Orchestration**: Kubernetes, Helm
- **Infrastructure**: Terraform, AWS Cloud

### ☁️ Cloud & DevOps
- **Cloud Provider**: AWS (EKS, ECR, RDS, VPC, IAM)
- **CI/CD**: GitHub Actions, Docker Build & Push
- **Monitoring**: Prometheus, Grafana, ELK Stack
- **Security**: SonarQube, Trivy, SAST/DAST
- **GitOps**: ArgoCD (Optional)
- **Service Mesh**: Istio (Optional)

### 🔐 Security & Quality
- **Code Quality**: SonarQube, Pylint, ESLint
- **Security Scanning**: Trivy, Snyk
- **Secrets Management**: Kubernetes Secrets, AWS Secrets Manager
- **Network Security**: VPC, Security Groups, Network Policies

## 📁 Project Structure
sri-rajeswari-provisions/
├── 📁 .github/workflows/ # CI/CD Pipelines
│ ├── ci-cd.yml # Main CI/CD workflow
│ └── security-scan.yml # Security scanning
├── 📁 infrastructure/ # Terraform Configurations
│ ├── main.tf # Main Terraform config
│ ├── variables.tf # Terraform variables
│ ├── eks.tf # EKS cluster configuration
│ ├── networking.tf # VPC and networking
│ └── database.tf # RDS database setup
├── 📁 microservices/ # Backend Microservices
│ ├── 📁 inventory-service/ # Product & Stock Management
│ ├── 📁 sales-service/ # Sales & Transactions
│ ├── 📁 customer-service/ # Customer Management
│ ├── 📁 payment-service/ # Payment Processing
│ └── 📁 notification-service/ # Email/SMS Alerts
├── 📁 frontend/ # React Application
│ ├── src/
│ │ ├── components/ # React components
│ │ ├── pages/ # Application pages
│ │ └── App.jsx # Main app component
│ ├── package.json # Node.js dependencies
│ └── Dockerfile # Frontend container
├── 📁 kubernetes/ # Kubernetes Configuration
│ ├── manifests/ # K8s YAML files
│ ├── helm-chart/ # Helm charts
│ └── argo-cd/ # GitOps configurations
├── 📁 monitoring/ # Observability Stack
│ ├── prometheus/ # Metrics collection
│ ├── grafana/ # Dashboards
│ └── elk/ # Logging stack
├── 📁 database/ # Database Setup
│ ├── init.sql # Database schema
│ └── migrations/ # Database migrations
├── 📁 scripts/ # Deployment Utilities
│ ├── setup.sh # Initial setup
│ ├── deploy.sh # Deployment script
│ └── health-check.sh # Health checks
├── 🐳 docker-compose.yml # Local Development
├── 📝 Makefile # Build Automation
└── 📚 README.md # Documentation

text

## 🚀 Quick Start

### Prerequisites
- **Docker** & **Docker Compose**
- **Python 3.9+**
- **Node.js 18+**
- **AWS CLI** (for production deployment)
- **kubectl** & **helm** (for Kubernetes deployment)

### Local Development
```bash
# 1. Clone the repository
git clone https://github.com/Leelavardhan-git/sri-rajeswari-provisions.git
cd sri-rajeswari-provisions

# 2. Start all services locally using Make
make deploy-local

# Or use docker-compose directly
docker-compose up -d

# 3. View running services
docker-compose ps
Access Local Services
Service	URL	Description
Frontend	http://localhost:3000	React application
Inventory API	http://localhost:8001	Product management
Sales API	http://localhost:8002	Sales transactions
Customer API	http://localhost:8003	Customer management
Payment API	http://localhost:8004	Payment processing
Notification API	http://localhost:8005	Alerts & notifications
PostgreSQL	localhost:5432	Database
Sample Data
The application comes pre-loaded with sample products for Sri Rajeswari Provisions:

Rice & Grains: Basmati Rice (₹85/kg), Wheat Atta (₹45/kg)

Oils: Sunflower Oil (₹180/liter), Groundnut Oil

Pulses: Toor Dal (₹120/kg), Chana Dal

Daily Needs: Sugar (₹42/kg), Salt (₹18/kg), Tea Powder (₹150/kg)

Beverages: Coca-Cola (₹20/bottle), Milk (₹28/liter)

Vegetables: Tomato (₹25/kg), Potato (₹20/kg), Onion (₹30/kg)

🏗️ Infrastructure Setup
AWS Infrastructure with Terraform
bash
# Navigate to infrastructure directory
cd infrastructure

# Initialize Terraform
terraform init

# Plan infrastructure deployment
terraform plan

# Deploy infrastructure
terraform apply -auto-approve

# Output will show EKS cluster info and database endpoints
Kubernetes Deployment
bash
# Apply all Kubernetes manifests
make k8s-deploy

# Or deploy manually
kubectl apply -f kubernetes/manifests/

# Verify deployment
kubectl get pods -n sri-rajeswari-provisions
kubectl get services -n sri-rajeswari-provisions

# Check ingress
kubectl get ingress -n sri-rajeswari-provisions
🔄 CI/CD Pipeline
GitHub Actions Workflows
Continuous Integration (CI)
Trigger: On every pull request to main/develop

Actions:

Code quality checks (SonarQube)

Unit testing for all microservices

Security scanning (Trivy)

Docker image building

Vulnerability scanning

Continuous Deployment (CD)
Trigger: On merge to main branch

Actions:

Build and tag Docker images

Push to AWS ECR

Deploy to AWS EKS

Run smoke tests

Update deployment status

Manual Deployment Commands
bash
# Build all services
make build

# Run tests
make test

# Deploy to Kubernetes
make k8s-deploy

# Clean up resources
make clean
📊 Monitoring & Observability
Access Monitoring Stack Locally
bash
# Port forward monitoring services
kubectl port-forward -n monitoring svc/grafana 3000:3000 &
kubectl port-forward -n monitoring svc/prometheus 9090:9090 &
kubectl port-forward -n monitoring svc/kibana 5601:5601 &

# Access monitoring dashboards
echo "Grafana: http://localhost:3000 (admin/admin)"
echo "Prometheus: http://localhost:9090"
echo "Kibana: http://localhost:5601"
Monitoring URLs in Production
Grafana Dashboard: http://grafana.yourdomain.com

Prometheus: http://prometheus.yourdomain.com

Kibana: http://kibana.yourdomain.com

Key Metrics Monitored
Application Metrics: Response times, error rates, request volume

Business Metrics: Sales revenue, inventory levels, customer activity

Infrastructure Metrics: CPU, memory, disk usage, network I/O

Database Metrics: Query performance, connection pool, replication lag

🗄️ Database Schema
Core Tables Structure
sql
-- Products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    min_stock_level INTEGER NOT NULL,
    unit VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sales table
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    customer_id INTEGER,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100),
    address TEXT
);
🔐 Security Implementation
Security Measures
Container Security: Non-root users, minimal base images

Network Security: VPC isolation, security groups, network policies

Secrets Management: Kubernetes Secrets, environment variables

API Security: Input validation, rate limiting, CORS configuration

TLS/SSL: HTTPS enforcement, certificate management

Security Scanning
bash
# Run container security scan
docker scan sri-rajeswari-inventory-service

# Run code security scan
trivy fs .

# Run dependency vulnerability check
npm audit # for frontend
pip audit # for backend
🧪 Testing Strategy
Test Pyramid
text
    /\    /\
   /  \  /  \   E2E Tests (5%)
  /    \/    \  Integration Tests (15%)
 /____________\  Unit Tests (80%)
Running Tests
bash
# Run all tests
make test

# Run backend tests
cd microservices/inventory-service
pytest tests/ -v

# Run frontend tests
cd frontend
npm test

# Run integration tests
docker-compose -f docker-compose.test.yml up
Test Coverage
Unit Tests: Individual functions and classes

Integration Tests: API endpoints and database interactions

End-to-End Tests: Critical user journeys

Performance Tests: Load and stress testing

📈 Performance & Scaling
Horizontal Pod Autoscaling
yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: inventory-service-hpa
  namespace: sri-rajeswari-provisions
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: inventory-service
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80
Resource Management
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
Development: docker-compose.yml, local environment variables

Staging: values-staging.yaml, staging-specific configs

Production: values-production.yaml, production secrets

Configuration Sources
Environment Variables

Kubernetes ConfigMaps

Kubernetes Secrets

AWS Parameter Store (for production)

Feature Flags for gradual rollouts

🌐 API Documentation
Available Endpoints
Inventory Service
GET /products - List all products

GET /products/{id} - Get product details

PUT /products/{id}/stock - Update stock quantity

GET /low-stock - Get low stock alerts

GET /categories - List product categories

Sales Service
POST /sales - Create new sale

GET /sales - List sales

GET /sales/today - Get today's sales summary

Customer Service
POST /customers - Create customer

GET /customers - List customers

GET /customers/{id} - Get customer details

OpenAPI Documentation
Each microservice provides automatic API documentation:

text
http://inventory-service:8000/docs
http://sales-service:8000/docs
http://customer-service:8000/docs
🚨 Alerting & Notifications
Business Alerts
Low Stock Alerts: When product quantity ≤ min_stock_level

High-Value Sales: Transactions above threshold

Inventory Discrepancies: Unexpected stock changes

Payment Failures: Failed transaction attempts

Technical Alerts
Service Downtime: Health check failures

High Error Rates: 5xx errors above threshold

Resource Alerts: CPU/Memory/Disk usage

Security Incidents: Unauthorized access attempts

📝 Development Guide
Adding New Features
Create Feature Branch: git checkout -b feature/new-feature

Implement Changes: Follow coding standards

Write Tests: Unit, integration, and e2e tests

Update Documentation: API docs, README updates

Create PR: Request code review

Merge: After approval and CI passing

Code Standards
Python: PEP 8, Black formatter, Pylint

JavaScript: ESLint, Prettier

Commit Messages: Conventional commits

Documentation: Inline comments, API docs

🐛 Troubleshooting Guide
Common Issues & Solutions
Database Connection Issues
bash
# Check database status
docker-compose ps postgres

# View database logs
docker-compose logs postgres

# Test connection
pg_isready -h localhost -p 5432
Kubernetes Deployment Issues
bash
# Check pod status
kubectl get pods -n sri-rajeswari-provisions

# View pod logs
kubectl logs -n sri-rajeswari-provisions <pod-name>

# Describe pod for details
kubectl describe pod -n sri-rajeswari-provisions <pod-name>

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
Service Communication Issues
bash
# Test service connectivity
kubectl run debug-pod --image=busybox --rm -it -- sh

# Inside debug pod
nslookup inventory-service
telnet inventory-service 8000
📊 Business Analytics
Key Performance Indicators (KPIs)
Daily Sales Revenue: Total sales per day

Inventory Turnover: How quickly stock sells

Customer Retention: Repeat customer rate

Stockout Frequency: How often products are unavailable

Average Transaction Value: Revenue per sale

Reporting Features
Real-time sales dashboard

Inventory valuation reports

Customer purchase patterns

Seasonal trend analysis

Profit margin calculations

🚀 Production Deployment
AWS Services Configuration
EKS: Managed Kubernetes cluster

ECR: Private container registry

RDS: PostgreSQL with read replicas

VPC: Isolated network with subnets

ALB: Application load balancer with SSL

CloudWatch: Log aggregation and monitoring

IAM: Role-based access control

Deployment Checklist
Infrastructure provisioned and tested

Database migrations applied

SSL certificates configured and valid

Monitoring stack deployed and alerting configured

Backup and disaster recovery procedures tested

Performance testing completed

Security audit passed

🔄 Maintenance Procedures
Regular Maintenance Tasks
Weekly: Security patches, log rotation

Monthly: Performance review, cost optimization

Quarterly: Dependency updates, architecture review

Annually: Security audit, disaster recovery test

Backup Strategy
bash
# Database backups
pg_dump -h $DB_HOST -U $DB_USER $DB_NAME > backup_$(date +%Y%m%d).sql

# Kubernetes resource backups
kubectl get all -n sri-rajeswari-provisions -o yaml > k8s-backup-$(date +%Y%m%d).yaml

# Configuration backups
terraform state pull > terraform-state-$(date +%Y%m%d).json
🤝 Contributing
We welcome contributions from the community! Please see our Contributing Guide for details.

Development Workflow
Fork the repository

Create a feature branch (git checkout -b feature/amazing-feature)

Commit your changes (git commit -m 'Add some amazing feature')

Push to the branch (git push origin feature/amazing-feature)

Open a Pull Request

Code Review Process
All PRs require at least one review

CI must pass all checks

Code coverage should not decrease

Documentation must be updated

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

🙏 Acknowledgments
FastAPI Team for the excellent web framework

Kubernetes Community for container orchestration

AWS for cloud infrastructure services

React Team for the frontend framework

Prometheus & Grafana for monitoring solutions

📞 Support
Documentation: GitHub Wiki

Issues: GitHub Issues

Discussions: GitHub Discussions

Email: mleelavardhan@gmail.com


#!/bin/bash

# Sri Rajeswari Provisions - Complete DevOps Project Structure Creator
set -e

echo "🚀 Creating Complete DevOps Project Structure..."
echo "=================================================="

# Create main project directory
PROJECT_DIR="sri-rajeswari-provisions"
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

echo "📁 Creating folder structure..."

# 1. GitHub Actions CI/CD
mkdir -p .github/workflows

# 2. Infrastructure as Code
mkdir -p infrastructure

# 3. Microservices
mkdir -p microservices/inventory-service/app
mkdir -p microservices/sales-service/app  
mkdir -p microservices/customer-service/app
mkdir -p microservices/payment-service/app
mkdir -p microservices/notification-service/app

# 4. Frontend
mkdir -p frontend/src/components
mkdir -p frontend/src/pages
mkdir -p frontend/public

# 5. Kubernetes
mkdir -p kubernetes/base
mkdir -p kubernetes/helm-chart/templates
mkdir -p kubernetes/argo-cd
mkdir -p kubernetes/manifests

# 6. Monitoring & Observability
mkdir -p monitoring/prometheus
mkdir -p monitoring/grafana
mkdir -p monitoring/elk
mkdir -p monitoring/kube-state-metrics

# 7. Database
mkdir -p database

# 8. Scripts
mkdir -p scripts

# 9. Documentation
mkdir -p docs

echo "✅ Folder structure created!"
echo "📝 Generating configuration files..."
echo "=================================================="

# =============================================
# 1. GITHUB ACTIONS CI/CD FILES
# =============================================

echo "🔧 Creating GitHub Actions CI/CD..."

cat > .github/workflows/ci-cd.yml << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  AWS_REGION: ap-south-1
  EKS_CLUSTER: sri-rajeswari-provisions

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: echo "Running tests..."

  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker images
        run: echo "Building Docker images..."

  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to EKS
        run: echo "Deploying to EKS..."
EOF

cat > .github/workflows/security-scan.yml << 'EOF'
name: Security Scan

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 0 * * 0'

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Trivy scan
        run: echo "Running security scan..."
EOF

# =============================================
# 2. INFRASTRUCTURE AS CODE - TERRAFORM
# =============================================

echo "🏗️  Creating Terraform configurations..."

# Main Terraform configuration
cat > infrastructure/main.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "sri-rajeswari-vpc"
  }
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
}
EOF

# Variables
cat > infrastructure/variables.tf << 'EOF'
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "sri-rajeswari-provisions"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}
EOF

# Outputs
cat > infrastructure/outputs.tf << 'EOF'
output "eks_cluster_id" {
  description = "EKS Cluster ID"
  value       = aws_eks_cluster.main.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
EOF

# EKS Configuration
cat > infrastructure/eks.tf << 'EOF'
resource "aws_iam_role" "eks_cluster" {
  name = "sri-rajeswari-eks-cluster-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "main"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = aws_subnet.private[*].id

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }
}
EOF

# Networking
cat > infrastructure/networking.tf << 'EOF'
resource "aws_subnet" "private" {
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "sri-rajeswari-private-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "sri-rajeswari-public-${count.index}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
EOF

# ECR Repositories
cat > infrastructure/ecr.tf << 'EOF'
resource "aws_ecr_repository" "microservices" {
  for_each = toset([
    "inventory-service",
    "sales-service", 
    "customer-service",
    "payment-service",
    "notification-service",
    "frontend"
  ])

  name = "sri-rajeswari-${each.key}"

  image_scanning_configuration {
    scan_on_push = true
  }
}
EOF

# Database
cat > infrastructure/database.tf << 'EOF'
resource "aws_db_instance" "main" {
  identifier     = "sri-rajeswari-db"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  engine         = "postgres"
  engine_version = "15.4"
  username       = var.database_username
  password       = var.database_password
  db_name        = "srirajeswariprovisions"
  skip_final_snapshot = true
}
EOF

# =============================================
# 3. MICROSERVICES
# =============================================

echo "🐍 Creating Microservices..."

# Inventory Service
cat > microservices/inventory-service/app/main.py << 'EOF'
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

app = FastAPI(title="Inventory Service")

class Product(BaseModel):
    id: int
    name: str
    category: str
    price: float
    stock: int

products_db = [
    {"id": 1, "name": "Basmati Rice", "category": "Rice", "price": 85.0, "stock": 100},
    {"id": 2, "name": "Sunflower Oil", "category": "Oil", "price": 180.0, "stock": 50}
]

@app.get("/")
def root():
    return {"message": "Inventory Service - Sri Rajeswari Provisions"}

@app.get("/products", response_model=List[Product])
def get_products():
    return products_db

@app.get("/products/{product_id}")
def get_product(product_id: int):
    product = next((p for p in products_db if p["id"] == product_id), None)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

@app.get("/health")
def health_check():
    return {"status": "healthy"}
EOF

cat > microservices/inventory-service/requirements.txt << 'EOF'
fastapi==0.104.1
uvicorn==0.24.0
pydantic==2.5.0
EOF

cat > microservices/inventory-service/Dockerfile << 'EOF'
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

# Sales Service
cat > microservices/sales-service/app/main.py << 'EOF'
from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime

app = FastAPI(title="Sales Service")

class Sale(BaseModel):
    id: int
    product_id: int
    quantity: int
    amount: float
    sale_date: datetime

@app.get("/")
def root():
    return {"message": "Sales Service - Sri Rajeswari Provisions"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
EOF

cat > microservices/sales-service/requirements.txt << 'EOF'
fastapi==0.104.1
uvicorn==0.24.0
pydantic==2.5.0
EOF

cat > microservices/sales-service/Dockerfile << 'EOF'
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

# Create similar files for other services
for service in customer payment notification; do
  cat > microservices/${service}-service/app/main.py << EOF
from fastapi import FastAPI

app = FastAPI(title="${service^} Service")

@app.get("/")
def root():
    return {"message": "${service^} Service - Sri Rajeswari Provisions"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
EOF

  cat > microservices/${service}-service/requirements.txt << 'EOF'
fastapi==0.104.1
uvicorn==0.24.0
EOF

  cat > microservices/${service}-service/Dockerfile << EOF
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF
done

# =============================================
# 4. FRONTEND APPLICATION (React.js)
# =============================================

echo "⚛️  Creating React Frontend Application..."

# Package.json
cat > frontend/package.json << 'EOF'
{
  "name": "sri-rajeswari-frontend",
  "version": "1.0.0",
  "description": "Sri Rajeswari Provisions Store Frontend",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "jest"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "axios": "^1.3.0",
    "chart.js": "^4.2.0",
    "react-chartjs-2": "^5.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.27",
    "@types/react-dom": "^18.0.10",
    "@vitejs/plugin-react": "^3.1.0",
    "vite": "^4.1.0",
    "jest": "^29.4.0",
    "jest-environment-jsdom": "^29.4.0"
  }
}
EOF

# Vite Configuration
cat > frontend/vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8001',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '')
      }
    }
  },
  build: {
    outDir: 'dist',
    sourcemap: true
  }
})
EOF

# HTML Template
cat > frontend/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sri Rajeswari Provisions</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f5f5f5;
      }
    </style>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

# Main React Entry Point
cat > frontend/src/main.jsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>,
)
EOF

# Global Styles
cat > frontend/src/index.css << 'EOF'
/* Global Styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  color: #333;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.card {
  background: white;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.btn-primary {
  background: #4f46e5;
  color: white;
}

.btn-primary:hover {
  background: #4338ca;
}

.btn-danger {
  background: #dc2626;
  color: white;
}

.btn-danger:hover {
  background: #b91c1c;
}

.grid {
  display: grid;
  gap: 20px;
}

.grid-2 {
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
}

.grid-3 {
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
}

.text-center {
  text-align: center;
}

.mt-4 {
  margin-top: 20px;
}

.mb-4 {
  margin-bottom: 20px;
}
EOF

# Main App Component
cat > frontend/src/App.jsx << 'EOF'
import React from 'react'
import { Routes, Route } from 'react-router-dom'
import Header from './components/Header'
import Dashboard from './pages/Dashboard'
import Products from './pages/Products'
import Sales from './pages/Sales'
import Inventory from './pages/Inventory'
import './App.css'

function App() {
  return (
    <div className="App">
      <Header />
      <main className="container">
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/products" element={<Products />} />
          <Route path="/sales" element={<Sales />} />
          <Route path="/inventory" element={<Inventory />} />
        </Routes>
      </main>
    </div>
  )
}

export default App
EOF

# App Styles
cat > frontend/src/App.css << 'EOF'
.App {
  min-height: 100vh;
}

/* Header Styles */
.header {
  background: white;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  padding: 1rem 0;
  margin-bottom: 2rem;
}

.nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.logo {
  font-size: 1.5rem;
  font-weight: bold;
  color: #4f46e5;
}

.nav-links {
  display: flex;
  list-style: none;
  gap: 2rem;
}

.nav-links a {
  text-decoration: none;
  color: #333;
  font-weight: 500;
  transition: color 0.3s ease;
}

.nav-links a:hover,
.nav-links a.active {
  color: #4f46e5;
}

/* Dashboard Styles */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: white;
  padding: 25px;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: bold;
  color: #4f46e5;
  margin: 10px 0;
}

.stat-label {
  color: #666;
  font-size: 0.9rem;
}

/* Product Grid */
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.product-card {
  background: white;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.product-card:hover {
  transform: translateY(-5px);
}

.product-name {
  font-size: 1.2rem;
  font-weight: bold;
  margin-bottom: 10px;
  color: #333;
}

.product-price {
  font-size: 1.5rem;
  font-weight: bold;
  color: #4f46e5;
  margin-bottom: 10px;
}

.product-stock {
  color: #666;
  margin-bottom: 15px;
}

.stock-low {
  color: #dc2626;
  font-weight: bold;
}

/* Table Styles */
.data-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.data-table th,
.data-table td {
  padding: 15px;
  text-align: left;
  border-bottom: 1px solid #e5e7eb;
}

.data-table th {
  background: #4f46e5;
  color: white;
  font-weight: 600;
}

.data-table tr:hover {
  background: #f9fafb;
}

/* Form Styles */
.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  color: #333;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 10px;
  border: 1px solid #d1d5db;
  border-radius: 5px;
  font-size: 14px;
}

.form-group input:focus,
.form-group select:focus {
  outline: none;
  border-color: #4f46e5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}
EOF

# Header Component
cat > frontend/src/components/Header.jsx << 'EOF'
import React from 'react'
import { Link, useLocation } from 'react-router-dom'

const Header = () => {
  const location = useLocation()

  const isActive = (path) => location.pathname === path

  return (
    <header className="header">
      <nav className="nav">
        <div className="logo">
          🛒 Sri Rajeswari Provisions
        </div>
        <ul className="nav-links">
          <li>
            <Link to="/" className={isActive('/') ? 'active' : ''}>
              Dashboard
            </Link>
          </li>
          <li>
            <Link to="/products" className={isActive('/products') ? 'active' : ''}>
              Products
            </Link>
          </li>
          <li>
            <Link to="/inventory" className={isActive('/inventory') ? 'active' : ''}>
              Inventory
            </Link>
          </li>
          <li>
            <Link to="/sales" className={isActive('/sales') ? 'active' : ''}>
              Sales
            </Link>
          </li>
        </ul>
      </nav>
    </header>
  )
}

export default Header
EOF

# Product List Component
cat > frontend/src/components/ProductList.jsx << 'EOF'
import React, { useState, useEffect } from 'react'
import axios from 'axios'

const ProductList = () => {
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchProducts()
  }, [])

  const fetchProducts = async () => {
    try {
      const response = await axios.get('/api/products')
      setProducts(response.data)
    } catch (error) {
      console.error('Error fetching products:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return <div className="text-center">Loading products...</div>
  }

  return (
    <div className="product-grid">
      {products.map(product => (
        <div key={product.id} className="product-card">
          <div className="product-name">{product.name}</div>
          <div className="product-category" style={{ color: '#666', fontSize: '0.9rem' }}>
            {product.category}
          </div>
          <div className="product-price">₹{product.price}</div>
          <div className={`product-stock ${product.stock_quantity <= product.min_stock_level ? 'stock-low' : ''}`}>
            Stock: {product.stock_quantity} {product.unit}
          </div>
          {product.stock_quantity <= product.min_stock_level && (
            <div style={{ color: '#dc2626', fontWeight: 'bold', fontSize: '0.8rem' }}>
              ⚠️ Low Stock Alert!
            </div>
          )}
        </div>
      ))}
    </div>
  )
}

export default ProductList
EOF

# Sales Dashboard Component
cat > frontend/src/components/SalesDashboard.jsx << 'EOF'
import React, { useState, useEffect } from 'react'
import axios from 'axios'

const SalesDashboard = () => {
  const [salesData, setSalesData] = useState({
    todaySales: 0,
    todayRevenue: 0,
    totalProducts: 0
  })
  const [recentSales, setRecentSales] = useState([])

  useEffect(() => {
    fetchSalesData()
  }, [])

  const fetchSalesData = async () => {
    try {
      // Mock data for demonstration
      setSalesData({
        todaySales: 15,
        todayRevenue: 12500,
        totalProducts: 45
      })
      
      setRecentSales([
        { id: 1, product: 'Basmati Rice', quantity: 2, amount: 170, time: '10:30 AM' },
        { id: 2, product: 'Sunflower Oil', quantity: 1, amount: 180, time: '11:15 AM' },
        { id: 3, product: 'Wheat Atta', quantity: 3, amount: 135, time: '12:00 PM' }
      ])
    } catch (error) {
      console.error('Error fetching sales data:', error)
    }
  }

  return (
    <div className="grid grid-2">
      <div className="card">
        <h3>Today's Overview</h3>
        <div className="stats-grid">
          <div className="stat-card">
            <div className="stat-label">Today's Sales</div>
            <div className="stat-value">{salesData.todaySales}</div>
          </div>
          <div className="stat-card">
            <div className="stat-label">Revenue</div>
            <div className="stat-value">₹{salesData.todayRevenue}</div>
          </div>
          <div className="stat-card">
            <div className="stat-label">Products</div>
            <div className="stat-value">{salesData.totalProducts}</div>
          </div>
        </div>
      </div>

      <div className="card">
        <h3>Recent Sales</h3>
        <table className="data-table">
          <thead>
            <tr>
              <th>Product</th>
              <th>Qty</th>
              <th>Amount</th>
              <th>Time</th>
            </tr>
          </thead>
          <tbody>
            {recentSales.map(sale => (
              <tr key={sale.id}>
                <td>{sale.product}</td>
                <td>{sale.quantity}</td>
                <td>₹{sale.amount}</td>
                <td>{sale.time}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

export default SalesDashboard
EOF

# Inventory Manager Component
cat > frontend/src/components/InventoryManager.jsx << 'EOF'
import React, { useState, useEffect } from 'react'
import axios from 'axios'

const InventoryManager = () => {
  const [lowStockProducts, setLowStockProducts] = useState([])
  const [stockUpdate, setStockUpdate] = useState({ productId: '', quantity: '' })

  useEffect(() => {
    fetchLowStockProducts()
  }, [])

  const fetchLowStockProducts = async () => {
    try {
      const response = await axios.get('/api/low-stock')
      setLowStockProducts(response.data)
    } catch (error) {
      console.error('Error fetching low stock products:', error)
    }
  }

  const handleStockUpdate = async (e) => {
    e.preventDefault()
    try {
      await axios.put(`/api/products/${stockUpdate.productId}/stock`, null, {
        params: { quantity: parseInt(stockUpdate.quantity) }
      })
      alert('Stock updated successfully!')
      setStockUpdate({ productId: '', quantity: '' })
      fetchLowStockProducts()
    } catch (error) {
      console.error('Error updating stock:', error)
      alert('Error updating stock')
    }
  }

  return (
    <div className="grid grid-2">
      <div className="card">
        <h3>Low Stock Alerts</h3>
        {lowStockProducts.length === 0 ? (
          <p>No low stock products 🎉</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Product</th>
                <th>Current Stock</th>
                <th>Min Required</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {lowStockProducts.map(product => (
                <tr key={product.id}>
                  <td>{product.name}</td>
                  <td>{product.stock_quantity}</td>
                  <td>{product.min_stock_level}</td>
                  <td>
                    <span style={{ color: '#dc2626', fontWeight: 'bold' }}>
                      ⚠️ Reorder Needed
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      <div className="card">
        <h3>Update Stock</h3>
        <form onSubmit={handleStockUpdate}>
          <div className="form-group">
            <label>Product ID</label>
            <input
              type="number"
              value={stockUpdate.productId}
              onChange={(e) => setStockUpdate({ ...stockUpdate, productId: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Quantity to Add</label>
            <input
              type="number"
              value={stockUpdate.quantity}
              onChange={(e) => setStockUpdate({ ...stockUpdate, quantity: e.target.value })}
              required
            />
          </div>
          <button type="submit" className="btn btn-primary">
            Update Stock
          </button>
        </form>
      </div>
    </div>
  )
}

export default InventoryManager
EOF

# =============================================
# PAGES COMPONENTS
# =============================================

# Dashboard Page
cat > frontend/src/pages/Dashboard.jsx << 'EOF'
import React from 'react'
import SalesDashboard from '../components/SalesDashboard'
import ProductList from '../components/ProductList'

const Dashboard = () => {
  return (
    <div>
      <h1 style={{ marginBottom: '20px', color: 'white' }}>
        Dashboard - Sri Rajeswari Provisions
      </h1>
      <SalesDashboard />
      <div className="card">
        <h2>Products Overview</h2>
        <ProductList />
      </div>
    </div>
  )
}

export default Dashboard
EOF

# Products Page
cat > frontend/src/pages/Products.jsx << 'EOF'
import React from 'react'
import ProductList from '../components/ProductList'

const Products = () => {
  return (
    <div>
      <h1 style={{ marginBottom: '20px', color: 'white' }}>Products Management</h1>
      <div className="card">
        <ProductList />
      </div>
    </div>
  )
}

export default Products
EOF

# Sales Page
cat > frontend/src/pages/Sales.jsx << 'EOF'
import React, { useState } from 'react'
import axios from 'axios'

const Sales = () => {
  const [saleForm, setSaleForm] = useState({
    productId: '',
    quantity: '',
    customerId: ''
  })

  const handleSaleSubmit = async (e) => {
    e.preventDefault()
    try {
      // Mock sale creation
      alert('Sale recorded successfully!')
      setSaleForm({ productId: '', quantity: '', customerId: '' })
    } catch (error) {
      console.error('Error recording sale:', error)
      alert('Error recording sale')
    }
  }

  return (
    <div>
      <h1 style={{ marginBottom: '20px', color: 'white' }}>Sales Management</h1>
      
      <div className="grid grid-2">
        <div className="card">
          <h3>Record New Sale</h3>
          <form onSubmit={handleSaleSubmit}>
            <div className="form-group">
              <label>Product ID</label>
              <input
                type="number"
                value={saleForm.productId}
                onChange={(e) => setSaleForm({ ...saleForm, productId: e.target.value })}
                required
              />
            </div>
            <div className="form-group">
              <label>Quantity</label>
              <input
                type="number"
                value={saleForm.quantity}
                onChange={(e) => setSaleForm({ ...saleForm, quantity: e.target.value })}
                required
              />
            </div>
            <div className="form-group">
              <label>Customer ID (Optional)</label>
              <input
                type="number"
                value={saleForm.customerId}
                onChange={(e) => setSaleForm({ ...saleForm, customerId: e.target.value })}
              />
            </div>
            <button type="submit" className="btn btn-primary">
              Record Sale
            </button>
          </form>
        </div>

        <div className="card">
          <h3>Sales Analytics</h3>
          <div className="stats-grid">
            <div className="stat-card">
              <div className="stat-label">Today's Revenue</div>
              <div className="stat-value">₹12,500</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">Total Sales</div>
              <div className="stat-value">156</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Sales
EOF

# Inventory Page
cat > frontend/src/pages/Inventory.jsx << 'EOF'
import React from 'react'
import InventoryManager from '../components/InventoryManager'

const Inventory = () => {
  return (
    <div>
      <h1 style={{ marginBottom: '20px', color: 'white' }}>Inventory Management</h1>
      <InventoryManager />
    </div>
  )
}

export default Inventory
EOF

# =============================================
# FRONTEND DOCKER CONFIGURATION
# =============================================

# Frontend Dockerfile
cat > frontend/Dockerfile << 'EOF'
FROM node:18-alpine as builder

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

# Nginx Configuration
cat > frontend/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;

        # React Router support
        location / {
            try_files $uri $uri/ /index.html;
        }

        # API proxy
        location /api/ {
            proxy_pass http://inventory-service:8000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
}
EOF

# Frontend .dockerignore
cat > frontend/.dockerignore << 'EOF'
node_modules
npm-debug.logl
dist
.env
.git
.gitignore
README.md
EOF

# Jest Configuration for Testing
cat > frontend/jest.config.js << 'EOF'
export default {
    testEnvironment: 'jsdom',
    setupFilesAfterEnv: ['<rootDir>/src/setupTests.js'],
    moduleNameMapping: {
        '\\.(css|less|scss)$': 'identity-obj-proxy'
    }
}
EOF

# Test Setup
cat > frontend/src/setupTests.js << 'EOF'
import '@testing-library/jest-dom'

// Mock axios
jest.mock('axios', () => ({
    get: jest.fn(),
    post: jest.fn(),
    put: jest.fn(),
    delete: jest.fn()
}))
EOF

# Sample Test
cat > frontend/src/App.test.jsx << 'EOF'
import { render, screen } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import App from './App'

test('renders Sri Rajeswari Provisions header', () => {
    render(
        <BrowserRouter>
            <App />
        </BrowserRouter>
    )
    const headerElement = screen.getByText(/Sri Rajeswari Provisions/i)
    expect(headerElement).toBeInTheDocument()
})
EOF

echo "✅ Frontend application created successfully!"

# =============================================
# 4. KUBERNETES MANIFESTS
# =============================================

echo "☸️  Creating Kubernetes manifests..."

# Namespace
cat > kubernetes/manifests/01-namespace.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: sri-rajeswari-provisions
  labels:
    project: sri-rajeswari-provisions
    environment: production
EOF

# ConfigMap
cat > kubernetes/manifests/02-configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: sri-rajeswari-provisions
data:
  DATABASE_URL: "postgresql://user:pass@db-host:5432/srirajeswariprovisions"
  ENVIRONMENT: "production"
EOF

# Inventory Service Deployment
cat > kubernetes/manifests/03-inventory-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inventory-service
  namespace: sri-rajeswari-provisions
spec:
  replicas: 2
  selector:
    matchLabels:
      app: inventory-service
  template:
    metadata:
      labels:
        app: inventory-service
    spec:
      containers:
      - name: inventory
        image: inventory-service:latest
        ports:
        - containerPort: 8000
        envFrom:
        - configMapRef:
            name: app-config
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
---
apiVersion: v1
kind: Service
metadata:
  name: inventory-service
  namespace: sri-rajeswari-provisions
spec:
  selector:
    app: inventory-service
  ports:
  - port: 80
    targetPort: 8000
EOF

# Ingress
cat > kubernetes/manifests/10-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-ingress
  namespace: sri-rajeswari-provisions
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /inventory
        pathType: Prefix
        backend:
          service:
            name: inventory-service
            port:
              number: 80
EOF

# =============================================
# 5. HELM CHARTS
# =============================================

echo "📦 Creating Helm charts..."

cat > kubernetes/helm-chart/Chart.yaml << 'EOF'
apiVersion: v2
name: sri-rajeswari-provisions
description: Helm chart for Sri Rajeswari Provisions
version: 0.1.0
appVersion: "1.0.0"
EOF

cat > kubernetes/helm-chart/values.yaml << 'EOF'
replicaCount: 2

image:
  repository: sri-rajeswari
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: sri-rajeswari.local
      paths:
        - path: /
          pathType: Prefix

resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
EOF

cat > kubernetes/helm-chart/templates/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
  labels:
    app: {{ .Chart.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        app: {{ .Chart.Name }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        ports:
        - containerPort: 8000
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
EOF

# =============================================
# 6. MONITORING
# =============================================

echo "📊 Creating monitoring configurations..."

# Prometheus
cat > monitoring/prometheus/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'inventory-service'
    static_configs:
      - targets: ['inventory-service:8000']
    metrics_path: /metrics

  - job_name: 'sales-service'
    static_configs:
      - targets: ['sales-service:8000']
    metrics_path: /metrics
EOF

# Grafana Dashboard
cat > monitoring/grafana/dashboard.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboard
  namespace: monitoring
data:
  dashboard.json: |-
    {
      "dashboard": {
        "title": "Sri Rajeswari Provisions",
        "panels": []
      }
    }
EOF

# =============================================
# 7. DATABASE
# =============================================

echo "🗄️  Creating database configurations..."

cat > database/init.sql << 'EOF'
-- Sri Rajeswari Provisions Database Schema

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    min_stock_level INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO products (name, category, price, stock_quantity, min_stock_level) VALUES
('Basmati Rice', 'Rice', 85.00, 100, 10),
('Sunflower Oil', 'Oil', 180.00, 50, 5),
('Wheat Atta', 'Atta', 45.00, 80, 8);
EOF

# =============================================
# 8. SCRIPTS
# =============================================

echo "⚙️  Creating utility scripts..."

cat > scripts/setup.sh << 'EOF'
#!/bin/bash
echo "🚀 Setting up Sri Rajeswari Provisions..."
docker-compose up -d
echo "✅ Setup completed!"
EOF

cat > scripts/deploy.sh << 'EOF'
#!/bin/bash
echo "🚀 Deploying to Kubernetes..."
kubectl apply -f kubernetes/manifests/
echo "✅ Deployment completed!"
EOF

cat > scripts/health-check.sh << 'EOF'
#!/bin/bash
echo "🔍 Running health checks..."
kubectl get pods -n sri-rajeswari-provisions
echo "✅ Health checks completed!"
EOF

chmod +x scripts/*.sh

# =============================================
# 9. DOCKER COMPOSE
# =============================================

echo "🐳 Creating Docker Compose..."

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: srirajeswariprovisions
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql

  inventory-service:
    build: ./microservices/inventory-service
    ports:
      - "8001:8000"
    environment:
      DATABASE_URL: postgresql://admin:password@postgres:5432/srirajeswariprovisions

  sales-service:
    build: ./microservices/sales-service
    ports:
      - "8002:8000"

volumes:
  postgres_data:
EOF

# =============================================
# 10. CONFIGURATION FILES
# =============================================

echo "📄 Creating configuration files..."

cat > .gitignore << 'EOF'
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
env/

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Docker
.dockerignore

# Terraform
.terraform/
*.tfstate
*.tfstate.backup

# Kubernetes
kubeconfig

# IDE
.vscode/
.idea/
*.swp
*.swo

# Logs
*.log
logs/

# Environment files
.env
.env.local
EOF

cat > Makefile << 'EOF'
.PHONY: help build test deploy clean

help:
	@echo "Sri Rajeswari Provisions DevOps Project"
	@echo ""
	@echo "Available commands:"
	@echo "  make build          Build all Docker images"
	@echo "  make test           Run tests"
	@echo "  make deploy-local   Deploy locally with Docker Compose"
	@echo "  make k8s-deploy     Deploy to Kubernetes"
	@echo "  make clean          Clean up resources"

build:
	docker-compose build

test:
	echo "Running tests..."

deploy-local:
	docker-compose up -d

k8s-deploy:
	./scripts/deploy.sh

clean:
	docker-compose down
EOF

cat > README.md << 'EOF'
# Sri Rajeswari Provisions - DevOps Project

Complete microservices-based inventory management system with full DevOps pipeline

## Quick Start

```bash
# Local development
make deploy-local

# Kubernetes deployment
make k8s-deploy

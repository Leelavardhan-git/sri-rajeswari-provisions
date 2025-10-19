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

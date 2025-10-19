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

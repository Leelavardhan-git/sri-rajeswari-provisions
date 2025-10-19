output "eks_cluster_id" {
  description = "EKS Cluster ID"
  value       = aws_eks_cluster.main.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

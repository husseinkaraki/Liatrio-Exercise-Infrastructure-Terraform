output "eks_name" {
  description = "The name of the eks cluster."
  value = aws_eks_cluster.eks_cluster.name
}
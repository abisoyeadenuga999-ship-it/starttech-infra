output "cluster_name" {
  value = aws_eks_cluster.starttech_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.starttech_cluster.endpoint
}

output "node_group_name" {
  value = aws_eks_node_group.starttech_node_group.node_group_name
}

output "node_security_group_id" {
  value = aws_eks_cluster.starttech_cluster.vpc_config[0].cluster_security_group_id
}

output "node_group_asg_name" {
  value = aws_eks_node_group.starttech_node_group.resources[0].autoscaling_groups[0].name
}

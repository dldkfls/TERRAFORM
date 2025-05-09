output "vpc_id" {
    value = aws_vpc.main.id
}

output "all_subnet_ids" {
    value = {
        public  = [for subnet in aws_subnet.public : subnet.id]
        compute = [for subnet in aws_subnet.compute_private : subnet.id]
        db      = [for subnet in aws_subnet.db_private : subnet.id]
        }
}

output "availability_zones" {
  value = var.azs
}
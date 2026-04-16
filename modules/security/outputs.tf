output "security_group_ids" {
  description = "IDs of security groups for the web, app, and database tiers."
  value = {
    web = aws_security_group.web.id
    app = aws_security_group.app.id
    db  = aws_security_group.db.id
  }
}

output "codebuild_project_name" {
  description = "The CodeBuild project created for infrastructure deployment."
  value       = aws_codebuild_project.project.name
}

output "codepipeline_name" {
  description = "The CodePipeline name used for the CI/CD pipeline."
  value       = aws_codepipeline.pipeline.name
}

output "artifact_bucket" {
  description = "S3 bucket used for pipeline artifacts."
  value       = aws_s3_bucket.artifact_store.bucket
}

output "codestar_connection_arn" {
  description = "ARN of the CodeStar Connection for GitHub."
  value       = var.codestar_connection_arn
}

output "debug_pipeline_stage_2_action_2" {
  value = aws_codepipeline.pipeline.stage[1].action[1].configuration
}

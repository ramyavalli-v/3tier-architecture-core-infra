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

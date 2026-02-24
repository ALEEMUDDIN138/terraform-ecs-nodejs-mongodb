resource "aws_secretsmanager_secret" "mongo_uri" {
  name = "mongo-uri"
}

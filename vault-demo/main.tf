resource "random_password" "password" {
  length  = 16
  special = false
  numeric = true
}



resource "vault_mount" "kvv2" {
  path        = "us/development"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}


resource "vault_mount" "kvv2us" {
  path        = "eu/development/"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "secret" {
  mount = "company_passwords"
  name  = "wordpress"
  data_json = jsonencode(
    {
      password = random_password.password.result
    }
  )
}



# resource "google_sql_database_instance" "wordpress" {
#   name                = "wordpress"
#   database_version    = "MYSQL_5_7"
#   region              = "us-central1"
#   deletion_protection = false

#   settings {
#     # Second-generation instance tiers are based on the machine
#     # type. See argument reference below.
#     tier = "db-f1-micro"
#   }
# }


# resource "google_sql_user" "users" {
#   name     = "wordpress"
#   instance = google_sql_database_instance.wordpress.name
#   host     = "wordpress.${var.google_domain_name}"
#   password = random_password.password.result
# }
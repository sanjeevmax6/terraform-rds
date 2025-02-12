variable "username_db" {
    type = string
    sensitive = true
}

variable "password_db" {
    type = string
    sensitive = true
}

variable "name_db" {
    type = string
    default = "wordpress_rds_blog"
}
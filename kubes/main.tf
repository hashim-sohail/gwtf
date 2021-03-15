provider "kubernetes" {
  config_path = "../kube_config_cluster.yml"
}

resource "kubernetes_namespace" "icap-adaptation" {
  metadata {
    name = "icap-adaptation"
  }
}

resource "kubernetes_namespace" "management-ui" {
  metadata {
    name = "management-ui"
  }
}

resource "kubernetes_namespace" "icap-ncfs" {
  metadata {
    name = "icap-ncfs"
  }
}

resource "kubernetes_secret" "docker-cfg" {
  metadata {
    name = "docker-cfg"
    namespace = "icap-adaptation"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "${var.registry_server}": {
      "auth": "${base64encode("${var.registry_username}:${var.registry_password}")}"
    }
  }
}
DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
}


resource "kubernetes_secret" "policyupdateservicesecret" {
  metadata {
    name = "policyupdateservicesecret"
    namespace = "icap-adaptation"
  }

  data = {
    username = "policy-management"
    password = "long-password"
  }

}

resource "kubernetes_secret" "transactionqueryservicesecret" {
  metadata {
    name = "transactionqueryservicesecret"
    namespace = "icap-adaptation"
  }

  data = {
    username = "query-service"
    password = "long-password"
  }

}

resource "kubernetes_secret" "rabbitmq-service-default-user" {
  metadata {
    name = "rabbitmq-service-default-user"
    namespace = "icap-adaptation"
  }

  data = {
    username = "guest"
    password = "guest"
  }

}

resource "kubernetes_secret" "ncfspolicyupdateservicesecret" {
  metadata {
    name = "ncfspolicyupdateservicesecret"
    namespace = "icap-ncfs"
  }

  data = {
    username = "guest"
    password = "guest"
  }

}

resource "kubernetes_secret" "transactionqueryserviceref" {
  metadata {
    name = "transactionqueryserviceref"
    namespace = "management-ui"
  }

  data = {
    username = "query-service"
    password = "long-password"
  }

}

resource "kubernetes_secret" "policyupdateserviceref" {
  metadata {
    name = "policyupdateserviceref"
    namespace = "management-ui"
  }

  data = {
    username = "policy-management"
    password = "long-password"
  }

}

resource "kubernetes_secret" "ncfspolicyupdateserviceref" {
  metadata {
    name = "ncfspolicyupdateserviceref"
    namespace = "management-ui"
  }

  data = {
    username = "policy-update"
    password = "long-password"
  }

}

resource "kubernetes_secret" "smtpsecret" {
  metadata {
    name = "smtpsecret"
    namespace = "management-ui"
  }

  data = {
    SmtpHost = var.SmtpHost
    SmtpPort = var.SmtpPort
    SmtpUser = var.SmtpUser
    SmtpPass = var.SmtpPass
    TokenSecret = var.TokenSecret
    TokenLifetime = var.TokenLifetime
    EncryptionSecret = var.EncryptionSecret
    ManagementUIEndpoint = var.ManagementUIEndpoint
    SmtpSecureSocketOptions = var.SmtpSecureSocketOptions
  }

}
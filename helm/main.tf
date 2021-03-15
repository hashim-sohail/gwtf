provider "helm" {
  kubernetes {
    config_path = "../kube_config_cluster.yml"
  }
}

resource "helm_release" "rabbitmq" {
  name       = "rabbitmq"
  chart      = "./helm_modules/rabbitmq"
  namespace  = "icap-adaptation"
}

resource "helm_release" "adaptation" {
  name       = "adaptation"
  chart      = "./helm_modules/adaptation"
  namespace  = "icap-adaptation"
}

resource "helm_release" "administration" {
  name       = "administration"
  chart      = "./helm_modules/administration"
  namespace  = "management-ui"
}

resource "helm_release" "ncfs" {
  name       = "ncfs"
  chart      = "./helm_modules/ncfs"
  namespace  = "icap-ncfs"
}
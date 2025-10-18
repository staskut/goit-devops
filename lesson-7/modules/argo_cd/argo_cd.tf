resource "helm_release" "argo_cd" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  recreate_pods = true
  replace       = true

  values = [
    file("${path.module}/values.yaml")
  ]

  create_namespace = true

  set = [
    {
      name  = "crds.keep"
      value = "false"
    }
  ]
}

resource "helm_release" "argo_apps" {
  name       = "${var.name}-apps"
  chart      = "${path.module}/charts"
  namespace  = var.namespace
  create_namespace = false

  values = [
    file("${path.module}/charts/values.yaml")
  ]
  depends_on = [helm_release.argo_cd]
}


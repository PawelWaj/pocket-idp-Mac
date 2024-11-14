variable "humanitec_org" {
  description = "The ID of the organization"
  type        = string
}

variable "kubeconfig" {
  description = "Kubeconfig used by the Humanitec Agent / terraform"
  type        = string
  default     = "/state/kube/config-internal.yaml"
}

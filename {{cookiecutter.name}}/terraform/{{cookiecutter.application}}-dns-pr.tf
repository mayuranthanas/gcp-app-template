module "{{ cookiecutter.application }}-np" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-dns-entry?ref=v0.0.3"
  project_id   = var.project_id
  managed_zone = module.dns-zone.name
  dns_name     = module.dns-zone.dns_name
  type         = "CNAME"
  name         = "{{ cookiecutter.application }}-np"
  cname        = module.dns-entry-webgw-private-yul-np-001.name
}

module "{{ cookiecutter.application }}" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-dns-entry?ref=v0.0.3"
  project_id   = var.project_id
  managed_zone = module.dns-zone.name
  dns_name     = module.dns-zone.dns_name
  type         = "CNAME"
  name         = "{{ cookiecutter.application }}"
  cname        = module.dns-entry-webgw-private-yul-pr-001.name
}
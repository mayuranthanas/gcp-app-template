resource "google_redis_instance" "cache" {
  project = var.project_id
  region		= "northamerica-northeast1"
  name           	= "{{ cookiecutter.name }}"
  tier           	= "STANDARD_HA"
  memory_size_gb 	= 1
  location_id        	= "northamerica-northeast1-a"
  connect_mode       	= "PRIVATE_SERVICE_ACCESS"
  authorized_network 	= "projects/bto-vpc-host-6296f13b/global/networks/bto-vpc-host-network"
  redis_version     	= "REDIS_5_0"
  display_name      	= "{{ cookiecutter.application }}"
}
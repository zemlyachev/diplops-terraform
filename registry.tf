# Yandex Container Registry
resource "yandex_container_registry" "diplops-reg" {
  name = "diplops-registry"
  folder_id = var.YC_FOLDER_ID
}
output "first_part_of_docker_image_tag" {
  value = "cr.yandex/${yandex_container_registry.diplops-reg.id}/"
}

# SA for registry
resource "yandex_iam_service_account" "sa-registry-puller" {
  folder_id = var.YC_FOLDER_ID
  name      = "sa-registry-puller"
}
resource "yandex_resourcemanager_folder_iam_member" "puller" {
  folder_id = var.YC_FOLDER_ID
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-registry-puller.id}"
}
resource "yandex_resourcemanager_folder_iam_member" "pusher" {
  folder_id = var.YC_FOLDER_ID
  role      = "container-registry.images.pusher"
  member    = "serviceAccount:${yandex_iam_service_account.sa-registry-puller.id}"
}

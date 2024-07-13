# Create init inventory file
resource "local_file" "inventory-init" {
  content    = <<EOF1
[kube-master]
${yandex_compute_instance.node-master.network_interface.0.nat_ip_address}
  EOF1
  filename   = "./ansible/inventory-init"
  depends_on = [yandex_compute_instance.node-master]
}

# Create Kubespray inventory
resource "local_file" "inventory-kubespray" {
  content    = <<EOF2
all:
  hosts:
    ${yandex_compute_instance.node-master.fqdn}:
      ansible_host: ${yandex_compute_instance.node-master.network_interface.0.ip_address}
      ip: ${yandex_compute_instance.node-master.network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.node-master.network_interface.0.ip_address}
%{ for worker in yandex_compute_instance.node-worker ~}
    ${worker.fqdn}:
      ansible_host: ${worker.network_interface.0.ip_address}
      ip: ${worker.network_interface.0.ip_address}
      access_ip: ${worker.network_interface.0.ip_address}
%{ endfor ~}
  children:
    kube_control_plane:
      hosts:
        ${yandex_compute_instance.node-master.fqdn}:
    kube_node:
      hosts:
%{ for worker in yandex_compute_instance.node-worker ~}
        ${worker.fqdn}:
%{ endfor ~}
    etcd:
      hosts:
        ${yandex_compute_instance.node-master.fqdn}:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
  EOF2
  filename   = "./ansible/inventory-kubespray"
  depends_on = [yandex_compute_instance.node-master, yandex_compute_instance.node-worker]
}

resource "openstack_compute_floatingip_associate_v2" "connection" {
  floating_ip = "${var.public_ip}" 
  instance_id = "${openstack_compute_instance_v2.user-vm.id}"
}

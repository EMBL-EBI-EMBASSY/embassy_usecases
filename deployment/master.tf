## Create a "Compute Instance" resource ##

resource "openstack_compute_instance_v2" "user-vm" {
  name            = "${var.vm_name}-vm"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.user-keypair.name}"
  security_groups = ["${openstack_networking_secgroup_v2.user-sg.name}"]
 
  network {
    uuid = "${openstack_networking_network_v2.user-network.id}"
  }
}


## Create a "Keypair" resource ##

resource "openstack_compute_keypair_v2" "user-keypair" {
  name = "keypair_${var.vm_name}"
  public_key = "${var.user_pubkey}"
}


## Create a "Security Group" resource ## 

resource "openstack_networking_secgroup_v2" "user-sg" {
  name        = "sg_${var.vm_name}"
  description = "Security group for the admin-bastion-vm"
}


## Create a "Security Group Rule" resource ##

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.user-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.user-sg.id}"
}

## Create a "Network" resource ##

resource "openstack_networking_network_v2" "user-network" {
  name           = "network_${var.vm_name}"
  admin_state_up = "true"
}


## Create a "Network Subnet" resource ##

resource "openstack_networking_subnet_v2" "user-subnet" {
  name            = "subnet_${var.vm_name}"
  network_id      = "${openstack_networking_network_v2.user-network.id}"
  cidr            = "${var.subnet_cidr}"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}


## Create a "Router Interface" resource ##

resource "openstack_networking_router_interface_v2" "router-iface" {
  router_id = "${var.routerid}"
  subnet_id = "${openstack_networking_subnet_v2.user-subnet.id}"
}

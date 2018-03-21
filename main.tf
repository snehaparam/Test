### Environment ###
  provider "opc" {
    user                = "${var.ociUser}"
    password            = "${var.ociPass}"
    identity_domain     = "${var.idDomain}"
    endpoint            = "${var.apiEndpoint}"
  }

### Network ###
  ### Network :: Shared Network ###
/*    ### Network :: Shared Network :: IP Reservation ###
    resource "opc_compute_ip_reservation" "reservation_instance_1" {
      parent_pool         = "/oracle/public/ippool"
      name                = "public_IP_Reservation_1"
      permanent           = true
    }
	
	### Network :: Shared Network :: Security Lists ###
    # A security list is a group of Oracle Compute Cloud Service instances that you can specify as the source or destination in one or more security rules. The instances in a
    # security list can communicate fully, on all ports, with other instances in the same security list using their private IP addresses.
    ###
    resource "opc_compute_security_list" "app-sec-list1" {
      name                 = "app-sec-list1"
      policy               = "deny"
      outbound_cidr_policy = "permit"
    }
	
    ### Network :: Shared Network :: Security Rules ###
    # Security rules are essentially firewall rules, which you can use to permit traffic
    # between Oracle Compute Cloud Service instances in different security lists, as well as between instances and external hosts.
    ###
    resource "opc_compute_sec_rule" "app-sec-rule1" {
      name             = "app-sec-rule1"
	  source_list      = "seciplist:${opc_compute_security_ip_list.sec-ip-list1.name}"
      destination_list = "seclist:${opc_compute_security_list.app-sec-list1.name}"
      action           = "permit"
      application      = "/oracle/public/http"
    }
    
	### Network :: Shared Network :: Security IP Lists ###
    # A security IP list is a list of IP subnets (in the CIDR format) or IP addresses that are external to instances in Compute Classic.
    # You can use a security IP list as the source or the destination in security rules to control network access to or from Compute Classic instances.
    ###	
      resource "opc_compute_security_ip_list" "sec-ip-list1" {
      name        = "sec-ip-list1-inet"
      ip_entries = [ "0.0.0.0/0" ]
    }
*/
	
### Storage ###
  ### Storage :: Application ###
  resource "opc_compute_storage_volume" "bootable-vol-1" {
    size                = "12"
    description         = "app-volume1: bootable storage volume"
    name                = "bootable-vol-1"
    storage_type        = "/oracle/public/storage/default"
    bootable            = true
    image_list          = "/oracle/public/OL_6.4_UEKR3_x86_64"
    image_list_entry    = 1
  }
  
### Compute ###
  ### Compute :: App ###
  resource "opc_compute_instance" "instance_1" {
    count = "${var.count}"
    name                = "instance1"
    label               = "instance1"
    shape               = "oc3"
    storage {
      index = 1
      volume            = "${opc_compute_storage_volume.bootable-vol-1.name}"
    }
    networking_info {
      index             = 1
      shared_network    = true
#      sec_lists         = ["${opc_compute_security_list.app-sec-list1.name}"]
#      nat               = ["${opc_compute_ip_reservation.reservation_instance_1.name}"]
#      name_servers      = ["8.8.8.8", "10.2.0.1"]
    }
	boot_order          = [ 1 ]
  }
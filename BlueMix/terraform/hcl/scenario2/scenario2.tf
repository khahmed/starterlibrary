provider "ibm" {
}

variable "public_ssh_key" {
  description = "Public SSH key used to connect to the virtual guest"
}

variable "datacenter" {
  description = "Softlayer datacenter where infrastructure resources will be deployed"
}



variable "first_hostname" {
  description = "Hostname of the second virtual instance (medium flavor) to be deployed"
  default = "ubuntu-medium"
}

# This will create a new SSH key that will show up under the \
# Devices>Manage>SSH Keys in the SoftLayer console.
resource "ibm_compute_ssh_key" "orpheus_public_key" {
    label = "Orpheus Public Key"
    public_key = "${var.public_ssh_key}"
}



# Create a new virtual guest using image "Ubuntu"
resource "ibm_compute_vm_instance" "ubuntu_medium_virtual_guest" {
    hostname = "${var.first_hostname}"
    #image_id = "${data.ibm_compute_image_template.ubuntu_16_04_01_64.id}"
    os_reference_code="UBUNTU_16_64"
    domain = "cam.ibm.com"
    datacenter = "${var.datacenter}"
    network_speed = 10
    hourly_billing = true
    private_network_only = false
    cores = 2
    memory = 8096
    user_metadata = "{\"value\":\"newvalue\"}"
    dedicated_acct_host_only = false
    local_disk = false
    ssh_key_ids = ["${ibm_compute_ssh_key.orpheus_public_key.id}"]
}


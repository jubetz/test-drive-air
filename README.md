# test-drive-air

### Cumulus Linux

Cumulus Linux is a software distribution that runs on top of industry standard networking hardware. It enables the latest Linux applications and automation tools on networking gear while delivering new levels of innovation and ﬂexibility to the data center.

For further details please see: [cumulusnetworks.com](http://www.cumulusnetworks.com)

### Building Test Drive Images for Cumulus AIR

#### Prerequisites

The following packages/applications need to be installed on the build host:

- ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- cloud-localds (via `cloud-image-utils` https://manpages.debian.org/testing/cloud-image-utils/cloud-localds.1.en.html)
- packer (https://www.packer.io/docs/install/index.html)

#### Create SSH keys

```
cd packer
./keygen.sh
```

#### Create a cloud-init config image to seed the initial provisioning key for Ubuntu images

```
cloud-localds ./artifacts/seed.img ./artifacts/user-data
```

#### Build the base images

```
packer build -var 'ssh_password=<PASSWORD>' oob-mgmt-server.json
packer build -var 'ssh_password=<PASSWORD>' oob-mgmt-switch.json
packer build -var 'ssh_password=<PASSWORD>' switch.json
packer build server.json
```

The resulting images can now be uploaded into Cumulus AIR and built into a bootcamp topology. An example topology definition is provided in `testdrive_topology.json`.

Then, create air image instances and get UUID.
- oob-mgmt-server
- oob-mgmt-switch
- testdrive-switch
- testdrive-server

Then update the OS in the .json with the image

Then, create the topology in AIR using the .json

Then, create a simulation instance using the topology instance.

Then start the topology and test it, Then power it off to get snapshot.

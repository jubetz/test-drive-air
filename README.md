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
- python3
- b2sdk (pip3 install b2sdk)

In the packer/ directory there are a few scripts. Run them in order.
They ask you for credentials interactively

1) ./build-images.sh
2) ./create-images.sh
3) python3 image-copy.py
4) ./create-air-topology.sh

Then you have to create a simulation instance from the topology instance - use swagger

Then boot the sim from the UI. 

Then wait for it to power on

Then install bootstrap and install netq

netq bootstrap master interface eth0 tarball s3://netq-archives/latest/netq-bootstrap-2.4.1.tgz

netq install opta standalone full interface eth0 bundle s3://netq-archives/latest/NetQ-2.4.1-opta.tgz config-key CMScARImZ3cuYWlyZGV2MS5uZXRxZGV2LmN1bXVsdXNuZXR3b3Jrcy5jb20YuwM=

netq install cli server (need to drop a file probably because of the opta-check: false)

make last min changes. Verify

Power off. That's the snapshot.








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

The resulting images can now be uploaded into Cumulus AIR and built into a test drive topology. An example topology definition is provided in `testdrive_topology.json`.

Then, create air image instances and get UUID.
- oob-mgmt-server
- oob-mgmt-switch
- testdrive-switch
- testdrive-server

Then update the OS in the .json with the image

Then, create the topology in AIR using the .json

Then, create a simulation instance using the topology instance.

Then start the topology and test it, Then power it off to get snapshot.

#!/bin/bash
#
#
# don't run as root
#

./keygen.sh

cloud-localds ./artifacts/seed.img ./artifacts/user-data

mkdir image-build
rm -rf output-qemu

packer build -var 'ssh_password=CumulusLinux!' oob-mgmt-server.json

mv output-qemu/oob-mgmt-server.qcow2 image-build/
rm -rf output-qemu

packer build -var 'ssh_password=CumulusLinux!' oob-mgmt-switch.json

mv output-qemu/oob-mgmt-switch.qcow2 image-build/
rm -rf output-qemu

packer build -var 'ssh_password=CumulusLinux!' switch.json

mv output-qemu/switch.qcow2 image-build/
rm -rf output-qemu

packer build server.json

mv output-qemu/server.qcow2 image-build/
rm -rf output-qemu

packer build netq-ts.json

mv output-qemu/netq-ts.qcow2 image-build/
rm -rf output-qemu

rm -rf packer_cache
# now create the images on AIR

#!/bin/bash
#

air_auth_url="https://staging.air.cumulusnetworks.com/api/v1/login/"
air_images_url="https://staging.air.cumulusnetworks.com/api/v1/image/"

### generates data for AIR auth via curl
generate_auth_post_data()
{
  cat <<EOF
  {
    "username": "$AIR_USERNAME",
    "password": "$AIR_PASSWORD"
  }
EOF
}

generate_air_image_create_data()
{
  cat <<EOF
  {
    "name": "$1",
    "base": "true",
    "mountpoint": "$2",
    "agent_enabled": "false"
  }
EOF
}

generate_netq_image_create_data()
{
  cat <<EOF
  {
    "name": "$1",
    "base": "true",
    "mountpoint": "$2",
    "agent_enabled": "true"
  }
EOF
}

#ask for AIR user/password
echo "Air Username:"
read AIR_USERNAME

echo "Air Password:"
read AIR_PASSWORD

## get air auth token before we enter loop
# curl -f fails and exits if http error
curl_output=`curl -f --header "Content-Type: application/json" \
  --request POST \
  --data "$(generate_auth_post_data)" \
  $air_auth_url`

## parse out auth token
auth_token=`echo $curl_output | jq '.["token"]' | sed -e 's/^"//' -e 's/"$//'`

#sanity check auth token
if [ -z "$auth_token" ]
then
  echo "Fail: detected auth token is empty"
  exit 1
fi
token_length=`expr length $auth_token`
if [ "$token_length" != "189" ]
then
  echo "Fail: auth_token seems to be the wrong size?"
  exit 1
fi

epoch_seconds=`date +%s`

#work on oob-mgmt-server
#generate the air name test_drive_oob-mgmt-server_$epoch_seconds
#submit to AIR get UUID
#rename oob-mgmt-server.qcow2 to the UUID.qcow2

image_name="testdrive_oob-mgmt-server_$epoch_seconds"
mountpoint="/dev/sda4" #for VX

curl_output=`curl -f --header "Content-Type: application/json" \
      --header "Authorization: Bearer $auth_token" \
      --request POST \
      --data "$(generate_air_image_create_data $image_name $mountpoint)" \
      $air_images_url`

UUID=`echo $curl_output | jq '.["id"]' | sed -e 's/^"//' -e 's/"$//'`

echo "Renaming oob-mgmt-server.qcow2 as ${UUID}.qcow2"  #with the UUID rename the file for next stage
mv image-build/oob-mgmt-server.qcow2 image-build/$UUID.qcow2
echo "oob_mgmt_server_uuid=$UUID" >uuid.txt

## oob-mgmt-switch

image_name="testdrive_oob-mgmt-switch_$epoch_seconds"
mountpoint="/dev/sda4" #for VX 

curl_output=`curl -f --header "Content-Type: application/json" \
      --header "Authorization: Bearer $auth_token" \
      --request POST \
      --data "$(generate_air_image_create_data $image_name $mountpoint)" \
      $air_images_url`

UUID=`echo $curl_output | jq '.["id"]' | sed -e 's/^"//' -e 's/"$//'`

echo "Renaming oob-mgmt-switch.qcow2 as ${UUID}.qcow2"  #with the UUID rename the file for next stage
mv image-build/oob-mgmt-switch.qcow2 image-build/$UUID.qcow2 
echo "oob_mgmt_switch_uuid=$UUID" >>uuid.txt

# switches

image_name="testdrive_switch_$epoch_seconds"
mountpoint="/dev/sda4" #for VX 

curl_output=`curl -f --header "Content-Type: application/json" \
      --header "Authorization: Bearer $auth_token" \
      --request POST \
      --data "$(generate_air_image_create_data $image_name $mountpoint)" \
      $air_images_url`

UUID=`echo $curl_output | jq '.["id"]' | sed -e 's/^"//' -e 's/"$//'`

echo "Renaming switch.qcow2 as ${UUID}.qcow2"  #with the UUID rename the file for next stage
mv image-build/switch.qcow2 image-build/$UUID.qcow2 
echo "switch_uuid=$UUID" >>uuid.txt

# servers

image_name="testdrive_server_$epoch_seconds"
mountpoint="/dev/sda1" #for ubuntu 

curl_output=`curl -f --header "Content-Type: application/json" \
      --header "Authorization: Bearer $auth_token" \
      --request POST \
      --data "$(generate_air_image_create_data $image_name $mountpoint)" \
      $air_images_url`

UUID=`echo $curl_output | jq '.["id"]' | sed -e 's/^"//' -e 's/"$//'`

echo "Renaming server.qcow2 as ${UUID}.qcow2"  #with the UUID rename the file for next stage
mv image-build/server.qcow2 image-build/$UUID.qcow2 
echo "server_uuid=$UUID" >>uuid.txt

# netq-ts

image_name="testdrive_netq-ts_$epoch_seconds"
mountpoint="/dev/sda1" #for ubuntu 

curl_output=`curl -f --header "Content-Type: application/json" \
      --header "Authorization: Bearer $auth_token" \
      --request POST \
      --data "$(generate_netq_image_create_data $image_name $mountpoint)" \
      $air_images_url`

UUID=`echo $curl_output | jq '.["id"]' | sed -e 's/^"//' -e 's/"$//'`

echo "Renaming netq-ts.qcow2 as ${UUID}.qcow2"  #with the UUID rename the file for next stage
mv image-build/netq-ts.qcow2 image-build/$UUID.qcow2 
echo "netq_ts_uuid=$UUID" >>uuid.txt

echo "##########################################"
echo "# Job ID: $epoch_seconds                 #"
echo "##########################################"

exit 0



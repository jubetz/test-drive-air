#!/bin/bash

air_org="43d4fefe-89be-433e-827e-070581e2a480" #Cumulus Networks Staging, use swagger to find it
topology_mgmt_url="https://staging.air.cumulusnetworks.com/api/v1/topology/"
air_auth_url="https://staging.air.cumulusnetworks.com/api/v1/login/"

#import the uuids from the file 
#comes from running create-images.sh script
. uuid.txt

echo "Var Dump:"
echo "oob-mgmt-switch: $oob_mgmt_switch_uuid"
echo "oob-mgmt-server: $oob_mgmt_server_uuid"
echo "netq-ts: $netq_ts_uuid"
echo "switch: $switch_uuid"
echo "server: $server_uuid"

generate_topology_json_data()
{
  cat <<EOF
{
    "name": "Cumulus Linux Test Drive",
    "organization": "$air_org",
    "nodes": [
        {
            "name": "oob-mgmt-switch",
            "os": "$oob_mgmt_switch_uuid",
            "memory": 768,
            "storage": 10,
            "cpu": 1,
            "interfaces": [
                {
                    "name": "eth0",
                    "mac_address": "a0:00:00:00:00:61"
                },
                {
                    "name": "swp1"
                },
                {
                    "name": "swp2"
                },
                {
                    "name": "swp3"
                },
                {
                    "name": "swp4"
                },
                {
                    "name": "swp5"
                },
                {
                    "name": "swp6"
                },
                {
                    "name": "swp7"
                }
            ]
        },
        {
            "name": "oob-mgmt-server",
            "os": "$oob_mgmt_server_uuid",
            "memory": 1024,
            "storage": 10,
            "cpu": 1,
            "interfaces": [
                {
                    "name": "eth0",
                    "outbound": true
                },
                {
                    "name": "eth1"
                }
            ]
        },
        {
            "name": "netq-ts",
            "os": "$netq_ts_uuid",
            "memory": 8192,
            "storage": 36,
            "cpu": 4,
            "interfaces": [
                {
                    "name": "eth0",
                    "mac_address": "a0:00:00:00:02:50"
                }
            ]
        },
        {
            "name": "spine01",
            "os": "$switch_uuid",
            "memory": 1024,
            "storage": 10,
            "cpu": 1,
            "interfaces": [
                {
                    "name": "eth0",
                    "mac_address": "a0:00:00:00:00:21"
                },
                {
                    "name": "swp1"
                },
                {
                    "name": "swp2"
                }
            ]
        },
        {
            "name": "leaf01",
            "os": "$switch_uuid",
            "memory": 1024,
            "storage": 10,
            "cpu": 1,
            "interfaces": [
                {
                    "name": "eth0",
                    "mac_address": "a0:00:00:00:00:11"
                },
                {
                    "name": "swp1"
                },
                {
                    "name": "swp2"
                },
                {
                    "name": "swp49"
                },
                {
                    "name": "swp50"
                },
                {
                    "name": "swp51"
                }
            ]
        },
        {
            "name": "leaf02",
            "os": "$switch_uuid",
            "memory": 1024,
            "storage": 10,
            "cpu": 1,
            "interfaces": [
                {
                    "name": "eth0",
                    "mac_address": "a0:00:00:00:00:12"
                },
                {
                    "name": "swp1"
                },
                {
                    "name": "swp2"
                },
                {
                    "name": "swp49"
                },
                {
                    "name": "swp50"
                },
                {
                    "name": "swp51"
                }
            ]
        },
        {
            "name": "server01",
            "os": "$server_uuid",
            "memory": 1024,
            "storage": 10,
            "cpu": 1,
            "interfaces": [
                {
                    "name": "eth0",
                    "mac_address": "a0:00:00:00:00:31"
                },
                {
                    "name": "eth1"
                },
                {
                    "name": "eth2"
                }
            ]
        },
        {
            "name": "server02",
            "os": "$server_uuid",
            "memory": 1024,
            "storage": 10,
            "cpu": 1,
            "interfaces": [
                {
                    "name": "eth0",
                    "mac_address": "a0:00:00:00:00:32"
                },
                {
                    "name": "eth1"
                },
                {
                    "name": "eth2"
                }
            ]
        }
    ],
    "links": [
        {
            "interfaces": [
                {
                    "node": "spine01",
                    "interface": "swp1"
                },
                {
                    "node": "leaf01",
                    "interface": "swp51"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "spine01",
                    "interface": "swp2"
                },
                {
                    "node": "leaf02",
                    "interface": "swp51"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "leaf01",
                    "interface": "swp1"
                },
                {
                    "node": "server01",
                    "interface": "eth1"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "leaf01",
                    "interface": "swp2"
                },
                {
                    "node": "server02",
                    "interface": "eth1"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "leaf02",
                    "interface": "swp1"
                },
                {
                    "node": "server01",
                    "interface": "eth2"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "leaf02",
                    "interface": "swp2"
                },
                {
                    "node": "server02",
                    "interface": "eth2"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "leaf01",
                    "interface": "swp49"
                },
                {
                    "node": "leaf02",
                    "interface": "swp49"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "leaf01",
                    "interface": "swp50"
                },
                {
                    "node": "leaf02",
                    "interface": "swp50"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "oob-mgmt-server",
                    "interface": "eth1"
                },
                {
                    "node": "oob-mgmt-switch",
                    "interface": "swp1"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "server01",
                    "interface": "eth0"
                },
                {
                    "node": "oob-mgmt-switch",
                    "interface": "swp2"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "server02",
                    "interface": "eth0"
                },
                {
                    "node": "oob-mgmt-switch",
                    "interface": "swp3"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "leaf01",
                    "interface": "eth0"
                },
                {
                    "node": "oob-mgmt-switch",
                    "interface": "swp4"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "leaf02",
                    "interface": "eth0"
                },
                {
                    "node": "oob-mgmt-switch",
                    "interface": "swp5"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "spine01",
                    "interface": "eth0"
                },
                {
                    "node": "oob-mgmt-switch",
                    "interface": "swp6"
                }
            ]
        },
        {
            "interfaces": [
                {
                    "node": "netq-ts",
                    "interface": "eth0"
                },
                {
                    "node": "oob-mgmt-switch",
                    "interface": "swp7"
                }
            ]
        }
    ]
}
EOF
}

generate_auth_post_data()
{
  cat <<EOF
  {
    "username": "$AIR_USERNAME",
    "password": "$AIR_PASSWORD"
  }
EOF
}


##################
#### START SCRIPT HERE
#######

#ask for AIR user/password
echo "Air Username:"
read AIR_USERNAME

echo "Air Password:"
read AIR_PASSWORD

## get air auth token
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


#post the topology

curl_output=`curl -f --header "Content-Type: application/json" \
  --header "Authorization: Bearer $auth_token" \
  --request POST \
  --data "$(generate_topology_json_data)" \
  $topology_mgmt_url`

echo "Response from AIR:"
echo $curl_output 
echo $curl_output | jq '.["url"]'

rm uuid.txt

exit 0

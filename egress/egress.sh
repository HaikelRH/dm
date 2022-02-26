#! /bin/bash

oc new-project egress-project

oc new-app --name app httpd


# UPDATE IPADDRESS
oc patch netnamespace egress-project --type=merge -p \
  '{
    "egressIPs": [
      "10.0.74.45"
    ]
  }'

# UPDATE CIDR

  oc patch hostsubnet node1 --type=merge -p \
  '{"egressCIDRs": ["10.0.74.0/24"]}'
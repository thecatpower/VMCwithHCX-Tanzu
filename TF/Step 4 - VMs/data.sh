#!/usr/bin/env bash

export GOVC_URL="https://vcenter.sddc-44-231-118-110.vmwarevmc.com/sdk"
export GOVC_USERNAME="cloudadmin@vmc.local"
export GOVC_PASSWORD="supersecret"
export GOVC_INSECURE=true

govc about

# Bring your OVA here. This is just an example

# extract VM specs with . . .
# govc import.spec ./vmc-demo.ova | python -m json.tool > vmc-demo.json
# govc import.spec ./photoapp-u.ova | python -m json.tool > photoapp-u.json
# and update Network

govc import.ova -dc="SDDC-Datacenter" -ds="WorkloadDatastore" -pool="Compute-ResourcePool" -folder="Templates" -options=./vmc-demo.json ./vmc-demo.ova
govc import.ova -dc="SDDC-Datacenter" -ds="WorkloadDatastore" -pool="Compute-ResourcePool" -folder="Templates" -options=./photoapp-u.json ./photoapp-u.ova


#!/bin/bash

INSTANCE_IP=$(terraform output -raw instance_public_ip)

echo "$INSTANCE_IP" > ../Ansi/inventory


#!/bin/bash

HOST_FILE="/root/hosts"
ERROR_FILE="/tmp/ssh-copy_error.txt"
PUBLIC_KEY_FILE="$1"


if [ ! -e .ssh ]; then
        mkdir .ssh
fi

if [ ! -e tmp ]; then
        mkdir tmp
fi

if [ ! -e tmp/ssh-copy_error.txt ]; then
        touch tmp/ssh-copy_error.txt
fi

ssh-keygen -t rsa -f .ssh/id_rsa -q -P ""

for IP in `cat $HOST_FILE`; do
        ssh-copy-id -i $PUBLIC_KEY_FILE root@$IP 2>$ERROR_FILE
        RESULT=$?
        if [ $RESULT -eq 0 ]; then
                echo ""
                echo "The public key was successfully copied to $IP"
                echo ""
        else
                echo "$(cat  $ERROR_FILE)"
                echo "" 
                exit 1
        fi
done

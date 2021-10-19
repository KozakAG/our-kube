#!/bin/bash

systemctl stop ufw
systemctl disable ufw

sudo swapoff -a
sudo rm /swap.img
sed -ri '/\sswap\s/s/^#?/#/' fstab












#!/bin/bash -e
DEB_VERSION=2021-04-21
if [ -d '/pi-gen/work/$DEB_VERSION-raspi/stage0/rootfs/debootstrap' ]; then
rm -rf   /pi-gen/work/$DEB_VERSION-raspi/stage0/rootfs/debootstrap/*
touch    /pi-gen/work/$DEB_VERSION-raspi/stage0/rootfs/debootstrap
rmdir -p /pi-gen/work/$DEB_VERSION-raspi/stage0/rootfs/debootstrap
fi

if [ -d '/pi-gen/work/$DEB_VERSION-raspi/stage0/rootfs' ]; then
rm -rf   /pi-gen/work/$DEB_VERSION-raspi/stage0/rootfs/*
touch    /pi-gen/work/$DEB_VERSION-raspi/stage0/rootfs
rmdir -p /pi-gen/work/$DEB_VERSION-raspi/stage0/rootfs
fi

if [ ! -d "${ROOTFS_DIR}" ] || [ "${USE_QCOW2}" = "1" ]; then
	bootstrap ${RELEASE} "${ROOTFS_DIR}" http://raspbian.raspberrypi.org/raspbian/
fi

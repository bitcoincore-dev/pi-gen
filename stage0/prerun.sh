#!/bin/bash -e

#rm -rf   /pi-gen/work/2021-03-30-raspi/stage0/rootfs/debootstrap/*
#touch    /pi-gen/work/2021-03-30-raspi/stage0/rootfs/debootstrap
#rmdir -p /pi-gen/work/2021-03-30-raspi/stage0/rootfs/debootstrap
#
#rm -rf   /pi-gen/work/2021-03-30-raspi/stage0/rootfs/*
#touch    /pi-gen/work/2021-03-30-raspi/stage0/rootfs
#rmdir -p /pi-gen/work/2021-03-30-raspi/stage0/rootfs

if [ ! -d "${ROOTFS_DIR}" ] || [ "${USE_QCOW2}" = "1" ]; then
	bootstrap ${RELEASE} "${ROOTFS_DIR}" http://raspbian.raspberrypi.org/raspbian/
fi

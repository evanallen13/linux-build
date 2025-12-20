#!/usr/bin/env bash
set -e

ROOTFS=rootfs
RELEASE=bookworm
ARCH=amd64

sudo rm -rf $ROOTFS
sudo debootstrap \
  --variant=minbase \
  --components=main \
  --arch=$ARCH \
  $RELEASE \
  $ROOTFS \
  http://deb.debian.org/debian

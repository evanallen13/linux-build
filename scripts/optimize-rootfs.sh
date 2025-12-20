#!/usr/bin/env bash
set -e

ROOTFS=rootfs

# Required mounts for kernel install
sudo mount --bind /dev  "$ROOTFS/dev"
sudo mount --bind /dev/pts "$ROOTFS/dev/pts"
sudo mount --bind /proc "$ROOTFS/proc"
sudo mount --bind /sys  "$ROOTFS/sys"

sudo chroot "$ROOTFS" /bin/bash <<'EOF'
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update

# REQUIRED for booting
apt-get install -y \
  linux-image-amd64 \
  live-boot \
  systemd-sysv

# Size optimization
apt-get purge -y \
  man-db \
  info \
  doc-base \
  cron \
  logrotate \
  rsyslog \
  nano \
  vim-tiny \
  tasksel \
  tasksel-data

apt-get autoremove -y
apt-get clean

rm -rf \
  /usr/share/doc/* \
  /usr/share/man/* \
  /usr/share/info/* \
  /usr/share/locale/* \
  /var/lib/apt/lists/*
EOF

# Cleanup mounts
sudo umount "$ROOTFS/dev/pts"
sudo umount "$ROOTFS/dev"
sudo umount "$ROOTFS/proc"
sudo umount "$ROOTFS/sys"

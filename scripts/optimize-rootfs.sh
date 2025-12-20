#!/usr/bin/env bash
set -e

ROOTFS=rootfs

sudo chroot $ROOTFS /bin/bash <<'EOF'
set -e

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

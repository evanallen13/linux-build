#!/usr/bin/env bash
set -e

ISO_NAME=$1
WORKDIR=iso
ROOTFS=rootfs

sudo rm -rf $WORKDIR
mkdir -p $WORKDIR/{boot/grub,live}

sudo mksquashfs $ROOTFS $WORKDIR/live/filesystem.squashfs -comp xz -e boot

cat <<EOF | sudo tee $WORKDIR/boot/grub/grub.cfg
set default=0
set timeout=3

menuentry "Minimal Debian" {
    linux /boot/vmlinuz boot=live quiet
    initrd /boot/initrd.img
}
EOF

sudo xorriso -as mkisofs \
  -iso-level 3 \
  -o $ISO_NAME \
  -full-iso9660-filenames \
  -volid "DEBIAN_MINIMAL" \
  -eltorito-boot boot/grub/i386-pc/eltorito.img \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  $WORKDIR

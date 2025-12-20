#!/usr/bin/env bash
set -e

ISO_NAME=$1
WORKDIR=iso
ROOTFS=rootfs

sudo rm -rf $WORKDIR
mkdir -p $WORKDIR/{boot/grub,live}

# Squash rootfs
sudo mksquashfs $ROOTFS $WORKDIR/live/filesystem.squashfs -comp xz -e boot

# Minimal GRUB config
cat <<EOF | sudo tee $WORKDIR/boot/grub/grub.cfg
set default=0
set timeout=3

menuentry "Minimal Debian" {
    linux /vmlinuz boot=live quiet
    initrd /initrd.img
}
EOF

# Copy kernel + initrd from rootfs
sudo cp $ROOTFS/boot/vmlinuz-* $WORKDIR/vmlinuz
sudo cp $ROOTFS/boot/initrd.img-* $WORKDIR/initrd.img

# Create hybrid ISO (BIOS + UEFI)
sudo grub-mkrescue \
  -o "$ISO_NAME" \
  "$WORKDIR"

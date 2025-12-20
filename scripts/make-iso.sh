#!/usr/bin/env bash
set -e

ISO_NAME=$1
ROOTFS=rootfs
ISO_DIR=iso
OUTPUT="$PWD/$ISO_NAME"

sudo rm -rf "$ISO_DIR"
mkdir -p "$ISO_DIR"/{boot/grub,live}

sudo mksquashfs \
  "$ROOTFS" \
  "$ISO_DIR/live/filesystem.squashfs" \
  -comp xz \
  -e boot

sudo cp "$ROOTFS"/boot/vmlinuz-* "$ISO_DIR/vmlinuz"
sudo cp "$ROOTFS"/boot/initrd.img-* "$ISO_DIR/initrd.img"

cat <<EOF | sudo tee "$ISO_DIR/boot/grub/grub.cfg"
set default=0
set timeout=3

menuentry "Minimal Debian Live" {
    linux /vmlinuz boot=live quiet
    initrd /initrd.img
}
EOF

# Build ISO
sudo grub-mkrescue -o "$OUTPUT" "$ISO_DIR" || true

# Make ISO readable by runner user
sudo chown "$USER:$USER" "$OUTPUT"

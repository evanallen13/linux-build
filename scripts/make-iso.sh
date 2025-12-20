
#!/usr/bin/env bash
set -e

ISO_NAME=$1
ROOTFS=rootfs
ISO_DIR=iso

sudo rm -rf "$ISO_DIR"
mkdir -p "$ISO_DIR"/{boot/grub,live}

# Create SquashFS
sudo mksquashfs \
  "$ROOTFS" \
  "$ISO_DIR/live/filesystem.squashfs" \
  -comp xz \
  -e boot

# Copy kernel + initrd
sudo cp "$ROOTFS"/boot/vmlinuz-* "$ISO_DIR/vmlinuz"
sudo cp "$ROOTFS"/boot/initrd.img-* "$ISO_DIR/initrd.img"

# GRUB config
cat <<EOF | sudo tee "$ISO_DIR/boot/grub/grub.cfg"
set default=0
set timeout=3

menuentry "Minimal Debian Live" {
    linux /vmlinuz boot=live quiet
    initrd /initrd.img
}
EOF

# Create hybrid ISO (BIOS + UEFI)
sudo grub-mkrescue \
  -o "$ISO_NAME" \
  "$ISO_DIR"

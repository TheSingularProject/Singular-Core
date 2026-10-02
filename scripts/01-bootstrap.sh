#!/usr/bin/env bash
set -euo pipefail

SUITE="bookworm"
ARCH="amd64"
MIRROR="http://deb.debian.org/debian"
ROOTFS_DIR="$(pwd)/rootfs"
PACKAGES_FILE="$(pwd)/packages/package.list"

if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Skrip ini harus dijalankan dengan sudo / root!" >&2
    exit 1
fi

if ! command -v debootstrap &> /dev/null; then
    echo "[INFO] debootstrap tidak ditemukan di host. Menginstal..."
    if command -v apt-get &> /dev/null; then
        apt-get update && apt-get install -y debootstrap
    elif command -v dnf &> /dev/null; then
        dnf install -y debootstrap
    fi
fi

EXTRA_PACKAGES=$(grep -v '^#' "$PACKAGES_FILE" | grep -v '^$' | tr '\n' ',' | sed 's/,$//')

echo "==> [1/3] Menjalankan debootstrap untuk Debian $SUITE ($ARCH)..."
debootstrap \
    --arch="$ARCH" \
    --variant=minbase \
    --include="$EXTRA_PACKAGES" \
    "$SUITE" \
    "$ROOTFS_DIR" \
    "$MIRROR"

echo "==> [2/3] Menyalin konfigurasi DNS host ke rootfs..."
cp -L /etc/resolv.conf "$ROOTFS_DIR/etc/resolv.conf"

echo "==> [3/3] Bootstrap selesai! Rootfs siap di $ROOTFS_DIR"
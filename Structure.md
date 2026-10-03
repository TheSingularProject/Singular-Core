singular-core/
├── Makefile                     # Shortcut otomasi (make build, make image, make clean)
├── conf/
│   ├── fstab                    # Tabel mount partisi (root=ro, data=rw, tmpfs)
│   ├── network-interfaces       # Konfigurasi IP statis/DHCP default
│   ├── limits.conf              # Pengaturan memlock untuk akselerasi RAM/VRAM
│   └── llama-server.service     # Unit systemd untuk auto-run inference engine
├── packages/
│   └── package.list             # Daftar paket debian minimalis esensial
├── rootfs/                      # Folder target hasil ekstraksi debootstrap (kosong di awal)
├── scripts/
│   ├── 01-bootstrap.sh          # Menjalankan debootstrap debian minimal
│   ├── 02-setup-chroot.sh       # Konfigurasi user, timezone, locale, & network di chroot
│   ├── 03-build-llama.sh        # Pull source & kompilasi llama.cpp langsung di chroot
│   ├── 04-hardening.sh          # Membuang file sampah, docs, manpages, dan cache apt
│   └── 05-make-image.sh         # Mengemas rootfs jadi file raw image / tarball LXC
└── README.md
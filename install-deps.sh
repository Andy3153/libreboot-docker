#!/bin/bash
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
set -euo pipefail

# lbmk's config runs plain "pacman -S --needed" w/o --noconfirm
cat > /usr/local/bin/pacman <<'EOF'
#!/bin/sh
exec /usr/bin/pacman --noconfirm --ask 4 "$@"
EOF
chmod 755 /usr/local/bin/pacman

pacman -Syu git sudo

git config --global user.name  "docker-build"
git config --global user.email "docker-build@localhost"

git clone --depth 1 https://codeberg.org/libreboot/lbmk.git /tmp/lbmk
(cd /tmp/lbmk && ./mk dependencies arch)

AUR_PKGS=$(sh -c '. /tmp/lbmk/config/dependencies/arch; echo $aur_notice')
echo "AUR packages to build: $AUR_PKGS"

useradd -m aurbuild
echo 'aurbuild ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/aurbuild

su -l aurbuild -c '
    set -e
    git clone --depth 1 https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
'

su -l aurbuild -c "yay -S --noconfirm --needed ${AUR_PKGS}"

pacman -Rns yay-bin

# Cleanup
rm -f /etc/sudoers.d/aurbuild
userdel -rf aurbuild || true
rm -rf /tmp/lbmk /root/.gitconfig
rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/*
rm -f /usr/local/bin/pacman

#!/bin/bash

# arch-bootstrap: Bootstrap a base Arch Linux system.
#
# Dependencies: coreutils, wget, sed, gawk, tar, gzip, chroot, xz.
# Bug tracker: http://code.google.com/p/tokland/issues
# Author: Arnau Sanchez <tokland@gmail.com>
#
# Install:
#
#   $ sudo install -m 755 arch-bootstrap.sh /usr/local/bin/arch-bootstrap
#
# Some examples:
#
#   $ sudo arch-bootstrap destination
#   $ sudo arch-bootstrap -a x86_64 -r "ftp://ftp.archlinux.org" destination_x86_64 
#
# And then you can chroot to the destination directory (default user: root/root):
#
#   $ sudo chroot destination

set -e -o pipefail -u

# Output to standard error
stderr() { echo "$@" >&2; }

# Output debug message to standard error
debug() { stderr "--- $@"; }

# Extract href attribute from HTML link
extract_href() { sed -n '/<a / s/^.*<a [^>]*href="\([^\"]*\)".*$/\1/p'; }

# Simple wrapper around wget
fetch() { wget -c --passive-ftp --quiet "$@"; }

### Main

# Packages needed by pacman (BASIC_PACKAGES) are obtained this way:
# 
#   $ for PACKAGE in $(ldd /usr/bin/pacman | grep "=> /" | awk '{print $3}'); do 
#       pacman -Qo $PACKAGE 
#     done | awk '{print $5}' | sort -u | xargs
BASIC_PACKAGES=(acl attr bzip2 expat glibc libarchive openssl pacman 
                pacman-mirrorlist xz zlib curl gpgme libssh2 libassuan libgpg-error)
EXTRA_PACKAGES=(coreutils bash grep gawk file tar initscripts)
PACKDIR="arch-bootstrap"
DEFAULT_REPO_URL="http://mirrors.kernel.org/archlinux"
DEFAULT_ARCH=i686

configure_pacman() {
  local DEST=$1; local ARCH=$2
  cp "/etc/resolv.conf" "$DEST/etc/resolv.conf"
  echo "Server = $REPO_URL/\$repo/os/$ARCH" >> "$DEST/etc/pacman.d/mirrorlist"
}

minimal_configuration() {
  local DEST=$1
  mkdir -p "$DEST/dev"
  echo "root:x:0:0:root:/root:/bin/bash" > "$DEST/etc/passwd"
  # create root user (password: root)
  echo 'root:$1$GT9AUpJe$oXANVIjIzcnmOpY07iaGi/:14657::::::' > "$DEST/etc/shadow"
  touch "$DEST/etc/group"
  echo "bootstrap" > "$DEST/etc/hostname"
  test -e "$DEST/etc/mtab" || echo "rootfs / rootfs rw 0 0" > "$DEST/etc/mtab"
  test -e "$DEST/dev/null" || mknod "$DEST/dev/null" c 1 3
  test -e "$DEST/dev/random" || mknod -m 0644 "$DEST/dev/random" c 1 8
  test -e "$DEST/dev/urandom" || mknod -m 0644 "$DEST/dev/urandom" c 1 9
  sed -i "s/^[[:space:]]*\(CheckSpace\)/# \1/" "$DEST/etc/pacman.conf"
}

check_compressed_integrity() {
  local FILEPATH=$1
  case "$FILEPATH" in
  *.gz) gunzip -t "$FILEPATH";;
  *.xz) xz -t "$FILEPATH";;
  *) debug "Error: unknown package format: $FILEPATH"
     return 1;;
  esac
}

uncompress() {
  local FILEPATH=$1; local DEST=$2
  case "$FILEPATH" in
  *.gz) tar xzf "$FILEPATH" -C "$DEST";;
  *.xz) xz -dc "$FILEPATH" | tar x -C "$DEST";;
  *) debug "Error: unknown package format: $FILEPATH"
     return 1;;
  esac
}  

usage() {
  stderr "Usage: $(basename "$0") [-a i686|x86_64] [-r REPO_URL] DESTINATION_DIRECTORY"
}

### Main

test $# -eq 0 && set -- "-h"
ARCH=$DEFAULT_ARCH;
REPO_URL=$DEFAULT_REPO_URL
while getopts "a:r:h" ARG; do
  case "$ARG" in
  a) ARCH=$OPTARG;;
  r) REPO_URL=$OPTARG;;
  *) usage; exit 1;;
  esac
done
shift $(($OPTIND-1))
test $# -eq 1 || { usage; exit 1; }
DEST=$1   

REPO="${REPO_URL%/}/core/os/$ARCH"
debug "using core repository: $REPO"

debug "create package directory: $PACKDIR"
mkdir -p "$PACKDIR"

LIST_HTML_FILE="$PACKDIR/core_os_$ARCH-index.html"
if ! test -s "$LIST_HTML_FILE"; then 
  debug "fetch packages list: $REPO/"
  # Force trailing '/' needed by FTP servers.
  fetch -O "$LIST_HTML_FILE" "$REPO/" ||
    { debug "Error: cannot fetch packages list: $REPO"; exit 1; }
fi

debug "packages HTML index: $LIST_HTML_FILE"
LIST=$(< "$LIST_HTML_FILE" extract_href | awk -F"/" '{print $NF}' | sort -rn)
test "$LIST" || 
  { debug "Error processing list file: $LIST_HTML_FILE"; exit 1; }  

debug "create destination directory: $DEST"
mkdir -p "$DEST"

debug "pacman package and dependencies: ${BASIC_PACKAGES[*]}"
for PACKAGE in ${BASIC_PACKAGES[*]}; do
  FILE=$(echo "$LIST" | grep -m1 "^$PACKAGE-[[:digit:]].*\(\.gz\|\.xz\)$") ||
    { debug "Error: cannot find package: $PACKAGE"; exit 1; }
  FILEPATH="$PACKDIR/$FILE"
  if ! test -e "$FILEPATH" || ! check_compressed_integrity "$FILEPATH"; then
    debug "download package: $REPO/$FILE"
    fetch -O "$FILEPATH" "$REPO/$FILE"
  fi
  debug "uncompress package: $FILEPATH"
  uncompress "$FILEPATH" "$DEST"
done

debug "configure DNS and pacman"
configure_pacman "$DEST" "$ARCH"

debug "re-install basic packages and install extra packages: ${EXTRA_PACKAGES[*]}"
minimal_configuration "$DEST"
LC_ALL=C chroot "$DEST" /usr/bin/pacman --noconfirm --arch $ARCH \
  -Syf ${BASIC_PACKAGES[*]} ${EXTRA_PACKAGES[*]}

debug "minimal configuration (DNS, passwd, hostname, mirrorlist, ...)" 
configure_pacman "$DEST" "$ARCH"

echo "Done! you can now use the system: chroot \"$DEST\""
echo "Note that some applications may require directories /dev, /proc or /sys to be mounted:"
echo "  $ sudo mount --bind /dev \"$DEST/dev\""

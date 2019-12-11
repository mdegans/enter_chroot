#!/bin/bash

# Copyright 2019 Michael de Gans
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# qemu binary location:
ARCH="aarch64"
BIN=$(which qemu-${ARCH}-static)

# parse arguments
if [[ $# -ne 1 ]] || [[ $1 == "--help" ]]; then
    echo "usage: $0 rootfs_path"
    exit 1
fi

# make sure we have the requisite permissions
if [[ $(id -u) -ne "0" ]]; then
    echo "this script must be run as root"
    exit 1
fi

# make sure qemu is installed
if [[ ! -f ${BIN} ]]; then
    echo "${BIN} not found. Please run: sudo apt install qemu-user-static"
fi

# be verbose, print every line in script from here on
set -x

# copy qemu to the rootfs
cp ${BIN} $1/usr/bin

# mount special filesystems
mount -t sysfs -o ro none $1/sys
mount -t proc -o ro none $1/proc
mount -t tmpfs none $1/tmp
mount -o bind,ro /dev $1/dev
mount -t devpts none $1/dev/pts
mount -o bind,ro /etc/resolv.conf $1/run/resolvconf/resolv.conf

# enter chroot
chroot $1

# unmount special filesystems
umount $1/sys
umount $1/proc
umount $1/tmp
umount $1/dev/pts
umount $1/dev
umount $1/run/resolvconf/resolv.conf

# remove qemu from the rootfs
rm $1${BIN}

# enter_chroot.sh

This script, copies qemu-aarch64-static to a rootfs, mounts special filesystems,
and then enters a chroot so you can interactively edit the rootfs prior to 
first boot. It's tested on ubuntu 18.04 x86-64.

enter_chroot.sh can be used to add .deb packages, add users, update the system, 
compile your software, and in some cases run tests on your software *before the 
first boot happens*.

```
usage: ./enter_chroot.sh rootfs_path
```

If you are on Tegra, for example, run `enter_chroot.sh rootfs`
from inside the Linux_for_Tegra folder that SDKManager downloads for you
for your board (~/nvidia/nvidia_sdk/JetPack_$(VERSION)/Linux_for_Tegra by
default as of writing).

## editing:

If you wish to use another architecture for emulation (eg, arm), please edit
the ARCH and/or BIN variables.

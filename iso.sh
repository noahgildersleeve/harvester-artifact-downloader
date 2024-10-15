#!/bin/bash
Help()
{
   # Display Help
   echo "This script will download the artifacts for seeder and the pxe boot for both amd64 and arm64."
   echo
   echo "Syntax: iso [version] [version-output] -arch"
   echo "options:"
   echo "[version]            version to be downloaded."
   echo "[version-output]     This is an optional output if you need a different name."
   echo "[x]                  Sets architecture to amd64."
   echo "[a]                  Sets architecture to arm64."
   echo
}

Setarch()
{
  if [ -z "$3" ]
  then
    arch=$2
  else
    arch=$3
  fi
  harvester_iso_url=https://releases.rancher.com/harvester/$1/harvester-$1-$arch.iso
  harvester_kernel_url=https://releases.rancher.com/harvester/$1/harvester-$1-vmlinuz-$arch
  harvester_ramdisk_url=https://releases.rancher.com/harvester/$1/harvester-$1-initrd-$arch
  harvester_rootfs_url=https://releases.rancher.com/harvester/$1/harvester-$1-rootfs-$arch.squashfs
  harvester_sha512=https://releases.rancher.com/harvester/$1/harvester-$1-$arch.sha512
}

while getopts ":hax" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

if [ -z "$1" ]
  then
    echo "No version selected for download"
    exit;
fi
# This will check if there is a separate output version and if not it will
# create a direcotry with the download version name
if [ -z "$2" ]
  then
    mkdir $1
    cd $1
else
    mkdir $2
    cd $2
    fi
if [ -z "$2" ]
  then
    Setarch $1 amd64
else
    Setarch $1 $2 amd64
    fi

# This checks if there is an extra output parameter and uses it
if [ -z "$2" ]
  then
    wget $harvester_iso_url -O harvester-$1-$arch.iso
    wget $harvester_kernel_url -O harvester-$1-vmlinuz-$arch
    wget $harvester_ramdisk_url -O harvester-$1-initrd-$arch
    wget $harvester_rootfs_url -O harvester-$1-rootfs-$arch.squashfs
    wget $harvester_sha512 -O harvester-$1-$arch.sha512
    sha512sum -c harvester-$1-$arch.sha512
else
  wget $harvester_iso_url -O harvester-$2-$arch.iso
  wget $harvester_kernel_url -O harvester-$2-vmlinuz-$arch
  wget $harvester_ramdisk_url -O harvester-$2-initrd-$arch
  wget $harvester_rootfs_url -O harvester-$2-rootfs-$arch.squashfs
fi
if [ -z "$2" ]
  then
    Setarch $1 arm64
else
    Setarch $1 $2 arm64
    fi
  if [ -z "$2" ]
  then
    wget $harvester_iso_url -O harvester-$1-$arch.iso
    wget $harvester_kernel_url -O harvester-$1-vmlinuz-$arch
    wget $harvester_ramdisk_url -O harvester-$1-initrd-$arch
    wget $harvester_rootfs_url -O harvester-$1-rootfs-$arch.squashfs
    wget $harvester_sha512 -O harvester-$1-$arch.sha512
    sha512sum -c harvester-$1-$arch.sha512
else
  wget $harvester_iso_url -O harvester-$2-$arch.iso
  wget $harvester_kernel_url -O harvester-$2-vmlinuz-$arch
  wget $harvester_ramdisk_url -O harvester-$2-initrd-$arch
  wget $harvester_rootfs_url -O harvester-$2-rootfs-$arch.squashfs
fi
cd ..

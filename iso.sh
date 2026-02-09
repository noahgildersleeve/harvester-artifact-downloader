#!/bin/bash
Help()
{
   # Display Help
   echo "This script will download the artifacts for seeder and the pxe boot for both amd64 and arm64."
   echo
   echo "Syntax: iso [version] [version-output] -s"
   echo "options:"
   echo "[version]            version to be downloaded."
   echo "[version-output]     This is an optional output if you need a different name."
   echo "-s                   This is optional if you need to symlink the destination directory to a existing release."
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
  harvester_netinstall_url=https://releases.rancher.com/harvester/$1/harvester-$1-amd64-net-install.iso
  harvester_sha512=https://releases.rancher.com/harvester/$1/harvester-$1-$arch.sha512
}
Setlink()
{
  # This sets the symbolic links to an existing release in the directory tree
  echo "$arch"
  ln -sf ../$1/harvester-$1-$arch.iso harvester-$2-$arch.iso
  ln -sf ../$1/harvester-$1-vmlinuz-$arch harvester-$2-vmlinuz-$arch
  ln -sf ../$1/harvester-$1-initrd-$arch harvester-$2-initrd-$arch
  ln -sf ../$1/harvester-$1-rootfs-$arch.squashfs harvester-$2-rootfs-$arch.squashfs 
}
Download()
{
  # This downloads the release and doesn't overwirte
  if [ -z "$2" ]
  then
    echo "first parameter"
    # This checks if the checksum works and re-downloads the artifcats if it doesn't
    wget $harvester_sha512 -O harvester-$1-$arch.sha512
    if
      ! output=$(sha512sum -c harvester-$1-$arch.sha512)
    then
      wget $harvester_iso_url -O harvester-$1-$arch.iso
      wget $harvester_netinstall_url -O harvester-$1-$arch-net-install.iso
      wget $harvester_kernel_url -O harvester-$1-vmlinuz-$arch
      wget $harvester_ramdisk_url -O harvester-$1-initrd-$arch
      wget $harvester_rootfs_url -O harvester-$1-rootfs-$arch.squashfs
    fi
  else
    if [ -z "$3" ]
      then
        # This downloads the release to a new directory that was already created.
        # It also overwrites anything there due to it being used with dynamic branches
        echo "second parameter"
        # This checks if the checksum works and re-downloads the artifcats if it doesn't
        wget $harvester_sha512 -O harvester-$1-$arch.sha512
        if
          ! output=$(sha512sum -c harvester-$1-$arch.sha512)
        then
          wget $harvester_iso_url -O harvester-$2-$arch.iso
          wget $harvester_netinstall_url -O harvester-$2-$arch-net-install.iso
          wget $harvester_kernel_url -O harvester-$2-vmlinuz-$arch
          wget $harvester_ramdisk_url -O harvester-$2-initrd-$arch
          wget $harvester_rootfs_url -O harvester-$2-rootfs-$arch.squashfs
        fi
      else
        echo "third parameter"
        mkdir ../$1
        cd ../$1
        # This checks if the checksum works and re-downloads the artifcats if it doesn't
        wget $harvester_sha512 -O harvester-$1-$arch.sha512
        if
          ! output=$(sha512sum -c harvester-$1-$arch.sha512)
        then
          wget $harvester_iso_url -O harvester-$1-$arch.iso
          wget $harvester_netinstall_url -O harvester-$1-$arch-net-install.iso
          wget $harvester_kernel_url -O harvester-$1-vmlinuz-$arch
          wget $harvester_ramdisk_url -O harvester-$1-initrd-$arch
          wget $harvester_rootfs_url -O harvester-$1-rootfs-$arch.squashfs
        fi
        cd ../$2
        Setlink $1 $2
      fi
    fi
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
# This goes through the parameters and downloads the files after setting the
# architecture each time
if [ -z "$3"]
  then
    if [ -z "$2" ]
      then
        Setarch $1 amd64
        Download $1
      else
        Setarch $1 $2 amd64
        Download $1 $2
        fi
  else
    Setarch $1 $2 amd64
    Download $1 $2 $3
    fi

if [ -z "$3" ]
  then
    if [ -z "$2" ]
      then
        Setarch $1 arm64
        Download $1
      else
        Setarch $1 $2 arm64
        Download $1 $2
        fi
  else
    Setarch $1 $2 arm64
    Download $1 $2 $3
    fi

# cd ..

# --- Snapmaker J1 (Qualcomm) ---
BOARD_NAME="Snapmaker J1"
BOARDFAMILY="msm8909"          # frei wählbar, muss zu sources/<family>.conf passen
LINUXFAMILY="msm8909"          # dito

RELEASE="bookworm"
BRANCH="snapmakerj1"

# U-Boot bauen wir nicht (lk2nd übernimmt die Rolle des First/Second Stage)
UBOOT_CONFIGURE="no"
BOOTCONFIG="none"

# KERNEL_CONFIGURE="no"
# KERNELSOURCE='https://github.com/msm8916-mainline/linux.git'
# KERNELBRANCH='tag:v6.12.1-msm8916'        # alternativ: branch:<name> oder tag:<vX.Y.Z>
# KERNEL_MAJOR_MINOR='6.12'
KERNEL_TARGET="snapmakerj1"
# KERNEL_GIT="shallow"

# Keine Armbian-Patches einmischen
KERNELPATCHDIR=''


# Root-FS und Kernel-Image-Format wie gewohnt
CLI_BETA="yes"                 # optional: CLI-Image-Variante erlauben
IMAGE_PARTITION_TABLE="gpt"    # sinnvoll auf eMMC
ARCH="armhf"

# Rockchip RK3328 in Artillery3D X4 Pro/Plus 3D-printer
# Makerbase MKS based board
# Quad core eMMC USB3 WIFI
# NDOR="Armbian"
BOARD_MAINTAINER="eazrael"
BUILD_MINIMAL="no"
#KERNEL_TARGET="current,edge"
SOURCE_COMPILE="yes"
# It's a printer
HAS_VIDEO_OUTPUT="yes"
BUILD_DESKTOP="no"
FULL_DESKTOP="no"
BOOT_LOGO="yes"
WIREGUARD="no"

#Settings for the internal emmc space
#FIXED_IMAGE_SIZE="7456"
#ROOTFS_TYPE="f2fs"
ROOTFS_TYPE="ext4"

SRC_EXTLINUX="yes"
declare -g EXTLINUX_UINITRD=no
# TODO hardcoded, derive 
SRC_CMDLINE="systemd.loglevel=info 8250.nr_uarts=0 fbcon=rotate:3 aus_armbian"
NAME_INITRD=initrd.img-6.12.1-snapmakerj1-msm8909
BOOTSIZE="120"
BOOTFS_TYPE="ext2"
AUFS="no"
# for testing no compression
COMPRESS_OUTPUTIMAGE="sha,none"
IMAGE_XZ_COMPRESSION_RATIO=9
BOOT_FDT_FILE="snapmakerj1.dtb"


# change "Armbian-unofficial
# No wireguard in a printer...
#PACKAGE_LIST_BOARD="xterm file armbian-config iotop-c"
PACKAGE_LIST_BOARD="xterm file iotop-c i2c-tools spi-tools linux-cpupower"
PACKAGE_LIST_BOARD_REMOVE="linux-dtb-current-rockchip64"
REPOSITORY_INSTALL="armbian-config armbian-firmware"
INSTALL_HEADERS="yes" # install kernel headers package
NETWORKING_STACK="network-manager"

function post_family_tweaks__msm8909_some_tweaks() {
    display_alert "${BOARD}"  "Disabling ramlog" "info"
    chroot_sdcard systemctl disable armbian-ramlog
    # Masking is the cleanest way of prevent this service, but then armbian-build fails
    # chroot_sdcard systemctl mask armbian-ramlog.service
    chroot_sdcard rm -f /lib/systemd/system/armbian-ramlog.service

    display_alert "${BOARD}"  "Disabling zram" "info"
    chroot_sdcard sed -i 's/^ENABLED=true$/ENABLED=false/' /etc/default/armbian-zram-config

#    display_alert "${BOARD}"  "Disabling default device trees" "info"
#    chroot_sdcard apt-mark hold linux-dtb-current-rockchip64
#	return 0
}

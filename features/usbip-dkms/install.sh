#!/usr/bin/env bash

KERNEL_VERSION="${KERNELVERSION:-}"
ENABLE_VUDC="${ENABLEVUDC:-false}"
AUTO_MODPROBE="${AUTOMODPROBE:-true}"

set -euo

if [ -z "$KERNEL_VERSION" ]; then
  KERNEL_VERSION="v$(uname -r | grep -Po '\d\.\d+')"
  if [ "$KERNEL_VERSION" == 'v' ]; then
     >&2 echo "Could not automatically determine kernel version. Please set kernelVersion in the feature config."
  fi
fi

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  dkms \
  git \
  "linux-headers-$(uname -r)" \
  "linux-tools-$(uname -r)" \
  subversion

# This is a trick to download only the usbip directory, and not the entire project.
svn export "https://github.com/torvalds/linux/tags/${KERNEL_VERSION}/drivers/usb/usbip" "/usr/src/usbip-${KERNEL_VERSION}"
install -m644 dkms.conf "/usr/src/usbip-${KERNEL_VERSION}/dkms.conf"

sed -i "s|#MODULE_VERSION#|${KERNEL_VERSION}|" "/usr/src/usbip-${KERNEL_VERSION}/dkms.conf"

export CONFIG_USBIP_CORE=m
export CONFIG_USBIP_VHCI_HCD=m
export CONFIG_USBIP_HOST=m

if [ "$ENABLE_VUDC" != "false" ]; then
  export CONFIG_USBIP_VUDC=m
  sed -i "s|# ||g" "/usr/src/usbip-${KERNEL_VERSION}/dkms.conf"
fi

dkms add -m usbip -v "${KERNEL_VERSION}"

if ! dkms build -m usbip -v "${KERNEL_VERSION}"; then
  >&2 echo "Could not build usbip kernel module"
  >&2 echo "build/make.log:"
  cat /var/lib/dkms/usbip/"${KERNEL_VERSION}"/build/make.log >&2
  exit 1
fi

dkms install -m usbip -v "${KERNEL_VERSION}"

mkdir -p /opt/usbip-dkms

echo "#!/usr/bin/env bash" > /opt/usbip-dkms/post-start.sh
chmod +x /opt/usbip-dkms/post-start.sh

if [ "$AUTO_MODPROBE" != "false" ]; then
  {
    echo "modprobe usbip-core"
    echo "modprobe usbip-host"
    echo "modprobe vhci-hcd"
  } >> /opt/usbip-dkms/post-start.sh
  if [ "$ENABLE_VUDC" != "false" ]; then
    echo "modprobe usbip-vudc" >>  /opt/usbip-dkms/post-start.sh
  fi
fi
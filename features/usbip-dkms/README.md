
# USBIP DKMS Module (usbip-dkms)

DKMS module for USBIP

## Example Usage

```json
"features": {
    "ghcr.io/h7x4/usbip-dkms-devcontainer-feature/usbip-dkms:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| kernelVersion | Kernel version to use for the source code of the USBIP modules. If not specified, the feature will try to determine the kernel version automatically, but this is not guaranteed to work. | string | - |
| enableVudc | Enable Virtual USB Device Controller (VUDC) support. This requires the kernel to have `CONFIG_USB_GADGET` enabled, which `linux-azure` (kernel used for GitHub Codespaces VMs) does not have by default. | boolean | false |
| autoModprobe | Automatically modprobe all modules after installation. | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/h7x4/usbip-dkms-devcontainer-feature/blob/main/features/usbip-dkms/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._


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
| kernelVersion | - | string | - |
| enableVudc | Enable Virtual USB Device Controller (VUDC) support. This requires the kernel to have CONFIG_USB_GADGET enabled, which linux-azure (GitHub Codespaces) does not have. | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/h7x4/usbip-dkms-devcontainer-feature/blob/main/features/usbip-dkms/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

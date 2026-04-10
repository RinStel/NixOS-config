{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    usbutils
    picocom
    minicom
  ];

  users.users.zikun.extraGroups = [ "dialout" ];

  services.udev.extraRules = ''
    # XDS110 调试器
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="bef3", MODE:="0660", GROUP="dialout"

    # XDS110 对应的串口
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="bef3", MODE:="0660", GROUP="dialout"

    # XDS110 对应的 hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="bef3", MODE:="0660", GROUP="dialout"

    # TI debug probes
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="a6d0", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="a6d1", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="bcd9", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="bcda", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="1cbe", ATTRS{idProduct}=="00fd", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="1cbe", ATTRS{idProduct}=="00ff", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="bef1", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="bef2", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="bef3", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="bef4", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="c31a", TAG+="uaccess", GROUP="dialout"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="c32a", TAG+="uaccess", GROUP="dialout"

    # avoid ModemManager grabbing TI devices
    ATTRS{idVendor}=="0451", ATTRS{idProduct}=="bef0", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="0c55", ATTRS{idProduct}=="0220", ENV{ID_MM_DEVICE_IGNORE}="1"

    # TI serial ports
    KERNEL=="ttyACM[0-9]*", TAG+="uaccess", GROUP="dialout"
  '';
}

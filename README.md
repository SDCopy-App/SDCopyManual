# SDCopy Manual

This repo contains the tech file of SDCopy to be viewed publicly.

# License Policy

1. Each device requires one license.
1. Each license should bind to a user, with name and email.
1. At our server side, log will be generated and kept when license quering.
1. When update package sent, one email will be sent to the licence owner and a record will be kept on our server.
1. If you beleave that your license is lost or stolen, contact support desk to change to a new one.
1. The log kept on our server will not be transferred to any people or group other than SDCopy development team.
3. We reserve the right to check the log frequently to identify and deactivate the license used in violation.

# Supported OS

Currently, SDCopy supports PiOS 10 (32-bit) and Ubuntu 20.04 LTS (64-bit) on Raspberry Pi 4.

# Install

## Steps to install using pre-built image

1. Use tool to write image to TF card.
1. Eject and replug the TF card.
1. Place the license file to the 1st partition as ```SDCopyLicense.txt```.
1. Place the wifi config file if required. While booting, if the file exists, existing network setting will be overwritten from this file, and the file will be removed after that.
   1. PiOS: Place a file ```wpa_supplicant.conf``` in the first partition. Check [PiOS](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md) for details.
   1. Ubuntu: Place a file ```netplan.yaml``` in the first partition. Check [Ubuntu](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#3-wifi-or-ethernet) for references. NOTE: File name is different from the official guide.
1. Eject the TF card.
1. Boot Raspberry Pi with the TF card.

Default user and password:
* (For Ubuntu) Default user name is ```ubuntu```, with password ```ubuntu```.
* (For PiOS) Default user name is ```pi```, with password ```raspberry```.

When required, edit the ```SDCopy.env```, which is a text file, placed in the 1st partition of the TF card. Check [EnvironmentFile](EnvironmentFile) folder for details.
The 1st partition is editable on Windows, Linux and MacOS. Do not format the 2nd partition form Windows.

## Steps to install this app manually

1. Install GDI+ and GPIO: ```apt install libgdiplus libgpiod-dev```
1. (For Ubuntu) Install RaspberryPi library: ```apt install libraspberrypi-bin```
1. (For PiOS) Enable SPI: use ```raspi-config```, or add ```dtparam=spi=on``` at the bottom of ```/boot/config.txt```. A reboot is required.
1. Copy the right version of ```SDCopy``` to ```/usr/bin/```.
1. Run command: ```sudo chmod +x /usr/bin/SDCopy```
1. Copy your own ```SDCopy.lic``` to ```/etc/```.
1. Copy the right version of ```SDCopy.env``` to ```/etc/```, ```/boot/``` or ```/boot/firmware/```.
1. Copy the right version of ```SDCopy.service``` which matched with the location of ```SDCopy.env``` to ```/etc/systemd/system```.
1. Run command: ```sudo systemctl daemon-reload```
1. (Optional) Run command to set the app start with booting: ```sudo systemctl enable SDCopy.service```
1. Run command to start the app: ```sudo systemctl start SDCopy.service```

(For Ubuntu) If you need the function to apply netplan from boot partition, like PiOS, while booting:

1. Copy ```NetplanCopy.sh``` to ```/etc/```.
1. Run command ```sudo chmod +x /etc/NetplanCopy.sh```.
1. Copy ```NetplanCopy.service``` to ```/etc/systemd/system```.
1. Run command ```sudo systemctl daemon-reload```.
1. Run command ```sudo systemctl enable NetplanCopy.service``` to set the service start while booting.

### Enviroment File
[EnvironmentFile](EnvironmentFile) folder contains the environment file and the description of all variables.

### Systemd File
[SystemdFile](SystemdFile) folder contains the service file for systemd.

# Steps to prepare the target disk

1. Format the disk with supported file system, like exFAT.
1. Put a folder in disk named ```Target```.

## Warning

We found some highend disks, like [Sandisk Extreme Pro Portable SSD (E81)](https://shop.westerndigital.com/products/portable-drives/sandisk-extreme-pro-usb-3-2-ssd), cannot work with Raspberry Pi, including PiOs and Ubuntu. The file system of the target will be destroyed when writing files to an unsupported disk. Do a test copy before use it is hightly recommended.

# Ejecting disks

* While scanning, copying (including the cancel confirming) and deleting, do not eject the disks operating.

* It's ok to unplug the source disk / SD card reader / SD card directly before source scanning, after copying and after deletion.

* It's ok to unplug the target disk before target scanning, after copying and after deletion.

* In other cases, unplugging the disk directly will not damage the files in the device, but may cause the copying or deletion process to be unable to continue.

# Flow
[Flow](Flow) folder contains the work flow description of SDCopy app, in png and Visio format.

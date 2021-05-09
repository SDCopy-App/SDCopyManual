# SDCopy Manual

This repo contains the tech file of SDCopy to be viewed publicly.

## Content
* Functions
  * [Main functions](#main-functions)
  * [Helpers](#helpers)
  * [Additional](#additional)
* License policy
* Supported OS
* Install
  * Steps to install using pre-built image
  * Steps to install this app manually
* Steps to prepare the target disk
* Ejecting disks
* Tested devices
* Flow
* Copyright

# Functions
## Main functions
1. Copy files from source to target.
   * Auto detect source based on folder matching.
   * Auto detect target based on folder matching.
   * Source subfolders / files filter to exclude subfolders / files from copying.
   * Target subfolder auto naming, manual naming and selecting.
   * Overwrite or resume when target subfolder exists.
   * Copying files with progress, speed and left time displayed.
   * Allow to delete source folder after all files copied successfully.
1. Clean source.
   * Auto detect source based on folder matching.
   * Delete all subfolders and files from source folder.
1. Delete target subfolder.
   * Auto detect target based on folder matching.
   * Select one subfolder under target folder.
   * Delete the subfolder specified with all subfolders and files.
1. Use Samba to view all files on device.

## Helpers
1. Network
   * Check all IPv4 addresses.
   * Check all known SSID.
   * Add new SSID, allow open SSID (no password) or WPA-PSK protected SSID (with password).
   * Remove SSID.
   * Restart Wifi Service.
   * Note: 
     * This helper works by editing the configuration files of netplan or wpa_supplicant. To use a complex networking, it still possible to edit your network manually.
     * To connect a wifi with web authentication page, a desktop environment is preferred for manual operation.
1. Date and Time
   * Check current date and time.
   * Set date and time manually.
   * Set NTP on or off.
   * Check and set the time zone.
   * Note: This helper works by communicating with ```timedatectl``` command.
1. Overlay File System (Pi OS only)
   * Check and change the status of Overlay File System.
   * Check and change the status of Boot partition mounting mode (read-only or read-write).
   * Do not allow to change system files and update SDCopy when Overlay File System is enabled.
   * Note: This helper works by communicating with ```raspi-config``` command.

## Additional
1. Hardware status monitoring
   * Check and display whether the Raspberry Pi hardware is under-voltage, frequency capped, throttled and over heated.
   * Prompt when Raspberry Pi hardware was under-voltage, frequency capped, throttled and over heated since last boot.
   * Prevent entering functions which may change file system, like copying or deleting, when under-voltage to avoid disk corruption.
   * Note: This function works by getting status from ```vcgencmd get_throttled``` command.
1. Allow user to change almost all settings through configuration files which is accessible from all computers with a TF card reader.
1. Allow user to add up to 9 custom commands and run them form SDCopy app though screen and keys.
1. Online update to keep SDCopy refreshed.
   * Note:
     * Internet connection is required.
     * Network fees may apply.

# License policy

1. Each device requires one license.
1. Each license should bind to a user, with name and email.
1. At our server side, log will be generated and kept when license quering.
1. When update package sent, one email will be sent to the licence owner and a record will be kept on our server.
1. If you believe that your license is lost or stolen, contact support desk to change to a new one.
1. The log kept on our server will not be transferred to any people or group other than SDCopy development team.
1. We reserve the right to check the log from time to time to identify and deactivate the license that violates the policy.

# Supported OS

Currently, SDCopy supports Pi OS 10 (32-bit, including normal, lite and full versions) and Ubuntu 20.04 LTS (64-bit) on Raspberry Pi 4.

# Install

## Steps to install using pre-built image

1. Use tool to write image to TF card.
1. Eject and replug the TF card.
1. Create a text file in the 1st partition named as ```SDCopyLicense.txt``` with your license key. Your license key is a string with 32 hexadecimal characters, without enter or any other texts.
1. Place the wifi config file if required. While booting, if the file exists, existing network setting will be overwritten from this file, and the file will be removed after that.
   * For Pi OS: Place a file ```wpa_supplicant.conf``` in the first partition. Check [Pi OS](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md) for details. An example file named ```(Example)wpa_supplicant.conf``` can be found at the same place.
   * For Ubuntu: Place a file ```netplan.yaml``` in the first partition. Check [Ubuntu](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#3-wifi-or-ethernet) for references. **Note: File name is different from the official guide.** An example file named ```(Example)netplan.yaml``` can be found at the same place.
1. Eject the TF card.
1. Boot Raspberry Pi with the TF card.

Note: While first booting, the partition is resized to fill to the TF card. A reboot may be triggered automatically.

When required, edit the ```SDCopy.env```, which is a text file, placed in the 1st partition of the TF card. Check [EnvironmentFile](EnvironmentFile) folder for details.
The 1st partition is editable on Windows, Linux and MacOS. Do not format the 2nd partition.

### Default user and password
* (For Pi OS) Default user name is ```pi```, with password ```raspberry```.
* (For Ubuntu) Default user name is ```ubuntu```, with password ```ubuntu```.

## Steps to install this app manually

1. Install GDI+, GPIO, Bluetooth libs: ```sudo apt install libgdiplus libgpiod-dev bluez```
1. (For Ubuntu) Install RaspberryPi library: ```sudo apt install libraspberrypi-bin pi-bluetooth```
1. (For Pi OS) Enable SPI: use ```sudo raspi-config``` - (Interfacing Options - SPI), or add ```dtparam=spi=on``` at the bottom of ```/boot/config.txt```. A reboot is required.
1. Copy the right version of ```SDCopy``` to ```/usr/bin/```.
1. Run command: ```sudo chmod +x /usr/bin/SDCopy```
1. Copy your own ```SDCopy.lic``` to ```/etc/```.
1. Copy the right version of ```SDCopy.env``` to ```/etc/```, ```/boot/``` or ```/boot/firmware/```.
1. Copy the right version of ```SDCopy.service``` which matched with the location of ```SDCopy.env``` to ```/etc/systemd/system/```.
1. Run command: ```sudo systemctl daemon-reload```
1. (Optional) Run command to set the app start with booting: ```sudo systemctl enable SDCopy.service```
1. Samba function:
   * If you want to enable Samba function:
     1. Install Samba: ```sudo apt install samba```
     1. Edit file ```/etc/samba/smb.conf```, find the line like ```;   include = /home/samba/etc/smb.conf.%m```, add a new line ```include = /etc/samba/SDCopy.conf``` below it.
     1. (Optional) If you need samba auto discovery:
        1. (For Ubuntu) Install avahi: ```sudo install avahi-daemon```. This package is included in Pi OS already.
        2. Create file ```/etc/avahi/services/samba.service``` with content below to enable auto discovery.
           ```
           <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
           <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
           
           <service-group>
             <name replace-wildcards="yes">%h</name>
             <service>
               <type>_smb._tcp</type>
               <port>445</port>
             </service>
           </service-group>
           ```
   * If you want to disable Samba function:
     * Edit ```SDCopy.env```, change the line started with ```SambaConfFileName``` to ```SambaConfFileName=```.
1. (For Ubuntu, Optional) If you need the function to apply netplan from boot partition, like Pi OS, while booting:
   1. Get files from [NetplanCopyForUbuntu](NetplanCopyForUbuntu).
   1. Copy ```NetplanCopy.sh``` to ```/etc/```.
   1. Run command ```sudo chmod +x /etc/NetplanCopy.sh```.
   1. Copy ```NetplanCopy.service``` to ```/etc/systemd/system/```.
   1. Run command ```sudo systemctl daemon-reload```.
   1. Run command ```sudo systemctl enable NetplanCopy.service``` to set the service start while booting.
1. (Optional) If you need to run script placed in the first partition at every boot:
   * For Pi OS:
     1. Get files from [ExecBootForPiOS](ExecBootForPiOS).
     1. Copy ```ExecBootScript.service``` to ```/etc/systemd/system```.
     1. Copy ```(Example)ExecBoot.sh``` to ```/boot```.
     1. Run command ```sudo systemctl daemon-reload```.
     1. Run command ```sudo systemctl enable ExecBootScript.service``` to set the service start while booting.
   * For Ubuntu:
     1. Get files from [ExecBootForUbuntu](ExecBootForUbuntu).
     1. Copy ```ExecBootScript.service``` to ```/etc/systemd/system```.
     1. Copy ```(Example)ExecBoot.sh``` to ```/boot/firmware```.
     1. Run command ```sudo systemctl daemon-reload```.
     1. Run command ```sudo systemctl enable ExecBootScript.service``` to set the service start while booting.
   * Use: The file in the first partition named ```ExecBoot.sh``` will be run by root at every boot when found. Reference ```(Example)ExecBoot.sh``` for example.

Finally, run this command to start the app: ```sudo systemctl start SDCopy.service```

### Enviroment File
[EnvironmentFile](EnvironmentFile) folder contains the environment file and the description of all variables.

### Systemd File
[SystemdFile](SystemdFile) folder contains the service file for systemd.

# Steps to prepare the target disk

1. Format the disk with supported file system, like exFAT.
1. Put a folder in disk named ```Target```.

# Ejecting disks

* While scanning, copying (including the cancel confirming) and deleting, do not eject the disks operating.
* While SMB server working, do not eject any disk mounted.
* It's ok to unplug the source disk / SD card reader / SD card directly before source scanning, after copying and after deletion.
* It's ok to unplug the target disk before target scanning, after copying and after deletion.
* In other cases, unplugging the disk directly will not damage the files in the device, but may cause the copying or deletion process to be unable to continue.

# Tested devices
Type|Brand|Product Name|Capacity|Product Code|Result
---|---|---|---|---|---
Card Reader|Kingston|MobileLite Plus microSD Reader|N/A|MobileLite Plus microSD Reader / MLPM|:heavy_check_mark:Passed
Card Reader|Kingston|MobileLite Plus SD Reader|N/A|MobileLite Plus SD Reader / MLP|:heavy_check_mark:Passed
Card Reader|UGREEN|2-in-1 USB C OTG Card Reader|N/A|CM185|:heavy_check_mark:Passed
HDD|Western Digital|Elements SE|5TB|WDBJRT0050BBK-WESN|:heavy_check_mark:Passed
SSD|HIKVISION|Portable SSD|1TB|T200N|:heavy_check_mark:Passed
SSD|SanDisk|Extreme Pro Portable SSD|2TB|SDSSDE81-2T00-G25|:x:Failed
DIY SSD|Western Digital &<br>ORICO|WD Blue SN550 NVMe SSD &<br>M.2 SSD Enclosure|1TB|WDS100T2B0C &<br>ORICO TCM2M-C3|:x:Failed
DIY SSD|Western Digital &<br>ORICO|WD Blue SATA SSD 2.5”/7mm cased &<br>2.5 inch Transparent Type-C Hard Drive Enclosure|2TB|WDS200T2B0A &<br>ORICO 2139C3|:heavy_check_mark:Passed

## Warning

We found some highend disks, like [SanDisk Extreme Pro Portable SSD (E81)](https://shop.westerndigital.com/products/portable-drives/sandisk-extreme-pro-usb-3-2-ssd), cannot work with Raspberry Pi, including Pi OS and Ubuntu. The file system of the target will be destroyed when writing files to an unsupported disk. Do a test copy before use it is hightly recommended.

# Flow
[Flow](Flow) folder contains the work flow description of SDCopy app, in png and Visio format.

# Copyright

Software and integration solution are copyright of CopyPi team, 2020-2021. All rights reserved.
Hardware copyright belongs to its author or producer.

## Referenced Libraries Copyright Notice

Library|Copyright|License
---|---|---
[SecretNest.Hardware.SinoWealth.SH1106BitmapExtension](https://www.nuget.org/packages/SecretNest.Hardware.SinoWealth.SH1106BitmapExtension/)|Allen Cui / SecretNest.info|[MIT](https://licenses.nuget.org/MIT)
[SecretNest.Hardware.VirtualKeyboard.128x64_Monochrome](https://www.nuget.org/packages/SecretNest.Hardware.VirtualKeyboard.128x64_Monochrome/)|Allen Cui / SecretNest.info|[MIT](https://licenses.nuget.org/MIT)
[SecretNest.Hardware.WaveShare.HAT_1Point3OLED](https://www.nuget.org/packages/SecretNest.Hardware.WaveShare.HAT_1Point3OLED/)|Allen Cui / SecretNest.info|[MIT](https://licenses.nuget.org/MIT)
[.NET BLE Server](https://github.com/phylomeno/dotnet-ble-server)|Roman Scheidegger|[MIT](https://github.com/phylomeno/dotnet-ble-server/blob/master/LICENSE)

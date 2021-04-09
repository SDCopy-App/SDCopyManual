# SDCopy 使用手册

本仓库包含有 SDCopy 公开的技术文档及资料。

# 授权政策

1. 每台设备需要一份注册码用于在线更新功能。
2. 每个注册码需要与一位用户进行绑定，用户信息包含姓名和电子邮箱。
3. 服务器会记录并保存注册码的使用记录。
4. 在更新过程中，服务器发送更新数据包后，注册码持有人将会收到电子邮件通知，并且也会记录在服务器中。
5. 如果您的注册码丢失，或认为您的注册码已泄露，请与客服联系更换新的注册码。
6. 服务器上储存的日志信息将不会透露给除 SDCopy 开发团队外的任何组织或个人。
7. SDCopy 开发团队将保留查看服务器日志并封禁有违规行为的注册码的权力。

# 操作系统支持

目前，SDCopy 支持运行在树莓派 4B 上的 [Raspberry Pi OS](https://www.raspberrypi.org/software/operating-systems/#raspberry-pi-os-32-bit) (32位) 与 [Ubuntu 20.04 LTS](https://ubuntu.com/download/raspberry-pi) (64位)。

# 安装

## 使用预构建镜像进行安装

1. 将镜像写入 Micro SD 存储卡中。
2. 弹出并重新插入 Micro SD 存储卡。
3. 将注册码文件保存于 Micro SD 存储卡的第一个分区，并命名为 ```SDCopyLicense.txt```
4. (可选) 将 Wi-Fi 配置文件保存与 Micro SD 存储卡的第一个分区。在每次开机过程中，若系统检测到存在配置文件，现有的 Wi-Fi 设置将会被配置文件的内容覆盖，覆盖后配置文件将会被删除。
   1. 对于 PiOS Lite 系统：参考 [PiOS](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md) 的配置方式，将文件名为 ```wpa_supplicant.conf``` 的网络配置文件存入 Micro SD 存储卡第一个分区。
   2. 对于 Ubuntu arm64 系统: 参考 [Ubuntu](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#3-wifi-or-ethernet) 的配置方式，将文件名为 ```netplan.yaml``` 的网络配置文件存入 Micro SD 存储卡第一个分区。**注意：此步骤配置文件名与官方文档不同。**
5. 弹出 Micro SD 存储卡。
6. 使用 Micro SD 存储卡启动树莓派。

说明：当系统第一次启动时，分区大小将被重新设置以填满整张 Micro SD 存储卡的可用空间，在此过程中系统可能会自动重启。

若需要修改环境变量，可参考 [EnvironmentFile](EnvironmentFile) 文件夹内环境变量说明编辑 Micro SD 存储卡第一个分区下 ```SDCopy.env``` 文件。首个分区可在 Windows，Linux 和 MacOS 系统下进行读写。请勿格式化存储卡第二个分区

## 默认 ssh 用户名及登录密码
* (PiOS) 默认用户名 ```pi```，默认密码 ```raspberry```
* (Ubuntu) 默认用户名 ```ubuntu```，默认密码 ```ubuntu```

# 手动安装软件
1. 安装 GDI 及 GPIO：```sudo apt install libgdiplus libgpiod-dev```
2. (对于 Ubuntu) 安装 RaspberryPi 库：```sudo apt install libraspberrypi-bin```
3. (对于 PiOS) 启用 SPI：使用 ```sudo raspi-config```；或在 ```/boot/config.txt``` 文件末尾添加一行 ```dtparam=spi=on```。修改完成后需要重启树莓派。
4. 将与系统匹配的软件 ```SDCopy``` 拷贝至 ```/usr/bin/```。
5. 在终端中执行 ```sudo chmod +x /usr/bin/SDCopy```
6. 将注册码文件 ```SDCopy.lic``` 拷贝至 ```/etc/```
7. 将与系统匹配的环境变量文件 ```SDCopy.env``` 拷贝至 ```/etc/```，```/boot/``` 或 ```/boot/firmware/```。
8. 将与系统匹配的服务文件 ```SDCopy.service``` 拷贝至 ```/etc/systemd/system/```。
9. 在终端中执行 ```sudo systemctl daemon-reload```
10. (可选) 设置让 SDCopy 开机启动 ```sudo systemctl enable SDCopy.service```
11. 启动 SDCopy ```sudo systemctl start SDCopy.service```

对于 Ubuntu 系统，若需要在每次开机自动从 ```/system-boot/``` 分区读取网络配置功能，请按如下设置：
1. 拷贝 ```NetplanCopy.sh``` 至 ```/etc/```。
2. 在终端中执行 ```sudo chmod +x /etc/NetplanCopy.sh```。
3. 拷贝 ```NetplanCopy.service``` 至 ```/etc/systemd/system/```。
4. 在终端中执行 ```sudo systemctl daemon-reload```。
5. 在终端中执行 ```sudo systemctl enable NetplanCopy.service``` 使脚本开机运行。

### Enviroment File
[EnvironmentFile](EnvironmentFile) 文件夹包含有环境变量文件及说明。

### Systemd File
[SystemdFile](SystemdFile) 文件夹包含有 systemd 服务文件。

# 目标硬盘的准备工作

1. 将目标硬盘格式化为树莓派支持的文件系统，例如 exFAT。
2. 在硬盘根目录新建名为 ```Target``` 的子目录。

## 注意

我们发现部分高端移动硬盘， 例如[Sandisk Extreme Pro Portable SSD (E81)](https://shop.westerndigital.com/products/portable-drives/sandisk-extreme-pro-usb-3-2-ssd)，在 PiOS 与 Ubuntu 系统下均无法正常工作。尝试向不兼容的移动硬盘写入数据将可能导致移动硬盘文件系统损坏。我们建议在使用之前对硬盘进行写入测试。

# 弹出硬盘

* 在扫描硬盘，拷贝数据 (在确认取消拷贝之前) 或删除数据过程中，请勿移除硬盘，这可能导致硬盘文件系统损坏。

* 在扫描硬盘之前或拷贝/删除数据完毕之后，您可以直接移除源存储设备或目标存储设备。

* 在其余情况下，直接移除硬盘并不会损坏硬盘内的文件，但可能导致无法继续拷贝或删除。

# 程序流程

[Flow](Flow) 文件夹包含有 SDCopy png 格式及 Visio 格式的工作流程描述。
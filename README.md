# Pre-compiled Guacamole Proxy Daemon packages
The repository contains instructions how to compile the Guacamole Proxy Daemon `guacd` to be used by the rport server.

It also contains ready-to-use packages for

Distribution | Version | Architectures
-------------|---------|--------------
 Debian      | 11 (bullseye) | [x86_64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_bullseye_x86_64.deb) [aarch64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_bullseye_aatch64.deb) [armv7l](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_bullseye_armv7l.deb)
Debian       |10 (buster) |  [x86_64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_buster_x86_64.deb) [aarch64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_buster_aarch64.deb) [armv7l](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_buster_armv7l.deb)
Ubuntu       |20.04 (focal) | [x86_64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_focal_x86_64.deb) [aarch64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_focal_aarch64.deb) [amrv7l](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_focal_armv7l.deb)
Ubuntu      | 18.04 (bionic) | [x86_64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_bionic_x86_64.deb)

> 🚫 **Do not use any of the above packages to build a fully featured Guacamole Server!**
>
> The packages are only suitable to run in combination with [rportd](https://github.com/cloudradar-monitoring/rport).

## Install packages on Debian
To install the Guacamole Proxy Daemon from pre-compiled packages, proceed as follows.
```bash
# Resolve dependencies first
apt install libcairo2 libjpeg62-turbo libpng16-16 libwebp6 libfontconfig1 libfreetype6 libfreerdp-client2-2 libssh2-1
# Download the package
. /etc/os-release
curl -LO https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_${VERSION_CODENAME}_$(uname -m).deb
# Install
dpkg -i rport-guacamole_1.4.0_debian_${VERSION_CODENAME}_$(uname -m).deb
```

## Install packages on Ubuntu
To install the Guacamole Proxy Daemon from our pre-compiled packages, proceed as follows.
```bash
# Resolve dependencies first
apt install libcairo2 libjpeg-turbo8 libpng16-16 libwebp6 libfontconfig1 libfreetype6 libfreerdp-client2-2 libssh2-1
# Download the package
. /etc/os-release
curl -LO https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_${VERSION_CODENAME}_$(uname -m).deb
# Install
dpkg -i rport-guacamole_1.4.0_ubuntu_${VERSION_CODENAME}_$(uname -m).deb
```

To avoid conflicts with a potentially already running instance of `guacd` it's installed to `/opt/rport-guacamole`.
By default, `guacd` listens only on localhost port 9445. To change the port, edit `/etc/default/rport-guacamole`. 

## Compile and package yourself
If you prefer to compile and package yourself, just execute the scripts of the repository on your machine.

To compile and build the Debian packages fastly, proceed as shown below.
```
export DEBIAN_FRONTEND=noninteractive
git clone https://cloudradar@bitbucket.org/cloudradar/rport-guacamole.git
cd port-guacamole
sh 01-resolve-debian-dependencies.sh
sh 02-compile-guacamole.sh
sh 03-create-deb.sh
sh 04-lintian.sh
```

### Popular pitfalls

If you compile yourself, heed the following advice:

* `guacd` writes some files on the fly into $HOME. Not all users have a writable home directory. The user `daemon` for example, cannot write files to $HOME.
* The `guacd` sometimes can't find the needed rdp libraries. Pass the library path when starting.

Example:
```bash
HOME=/tmp LD_LIBRARY_PATH=/opt/rport-guacamole/lib /opt/rport-guacamole/sbin/guacd -v
```

The pre-compiled packages ship with a systemd service that does all the above in the background.

## License
The [Apache Guacamole™ source code](https://guacamole.apache.org/) is released under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## Liability disclaimer
⚠️ Use the instructions or the pre-compiled packages at your own risk.

This repository is not part of the Apache Guacamole™ project.

## Notes

* The x86_64 packages and binaries are compiled and packaged on the [Bitbucket pipeline](https://bitbucket.org/product/en/features/pipelines) using the official docker images of the respective distributions.
* The aarch packages and binaries are compiled and packaged on the [Oracle Cloud](https://www.oracle.com/cloud/) using the LXD containers of the respective distributions.
* The armv7l packages and binaries are compiled and packaged on a [Odroid HC1](https://www.hardkernel.com/shop/odroid-hc1-home-cloud-one/) using the LXC containers of the respective distributions.
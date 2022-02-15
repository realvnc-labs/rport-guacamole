# Pre-compiled gucamole server packages
The repository contains instructions how to compile the gucamole server `guacd` to be used by the rport server.

It also contains ready-to-use packages for

* Debian 11 (bullseye) [x86_64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_bullseye_x86_64.deb) [aarch64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_bullseye_aatch64.deb)
* Debian 10 (buster) [x86_64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_buster_x86_64.deb) [aarch64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_buster_aarch64.deb) [armv7l](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_buster_armv7l.deb)
* Ubuntu 20.04 (focal) [x86_64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_focal_x86_64.deb) [aarch64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_focal_aarch64.deb)
* Ubuntu 18.04 (bionic) [x86_64](https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_bionic_x86_64.deb)

> 🚫 **Do not use any of the above packages to build a fully featured Guacamole server!**
>
> The packages are only suitable to run in combination with the [rportd](https://github.com/cloudradar-monitoring/rport).

## Install packages on Debian
To install the guacamole server from our pre-compiled packages, proceed as follows.
```bash
# Resolve dependencies first
apt install libcairo2 libjpeg62-turbo libpng16-16 libwebp6 libfontconfig1 libfreetype6
# Download the package
. /etc/os-release
curl -LO https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_debian_${VERSION_CODENAME}_$(uname -m).deb
# Install
dpkg -i rport-guacamole_1.4.0_debian_${VERSION_CODENAME}_$(uname -m).deb
```

## Install packages on Ubuntu
To install the guacamole server from our pre-compiled packages, proceed as follows.
```bash
# Resolve dependencies first
apt install libcairo2 libjpeg-turbo8 libpng16-16 libwebp6 libfontconfig1 libfreetype6
# Download the package
. /etc/os-release
curl -LO https://bitbucket.org/cloudradar/rport-guacamole/downloads/rport-guacamole_1.4.0_ubuntu_${VERSION_CODENAME}_$(uname -m).deb
# Install
dpkg -i rport-guacamole_1.4.0_ubuntu_${VERSION_CODENAME}_$(uname -m).deb
```

To avoid conflics with a potentially already running instance of `guacd` it's installed to `/opt/rport-guacamole`.
By default `guacd` listens only on localhost port 9445.

## Compile and package yourself
If you prefer to compile and package yourself, just execute the scripts of the repository on your machine.

## License
The [Apache Guacamole™ source code](https://guacamole.apache.org/) is released under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## Liability disclaimer
⚠️ Use the instructions or the pre-compiled packages at your own risk.

This repository is not part of the Apache Guacamole™ project.

The packages and binaries are compiled and packaged on the [Bitbucket pipeline](https://bitbucket.org/product/en/features/pipelines) using the oficial docker images of the respective distributions.
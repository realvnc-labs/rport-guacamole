#
# Create folder structure
#
PKG_NAME=rport-guacamole
PKG_ROOT=/pkg
test -e $PKG_ROOT && rm -rf $PKG_ROOT
mkdir -p ${PKG_ROOT}/opt
cp -a /opt/rport-guacamole ${PKG_ROOT}/opt
mkdir -p ${PKG_ROOT}/lib/systemd/system
mkdir -p ${PKG_ROOT}/etc/default/
mkdir -p ${PKG_ROOT}/opt/rport-guacamole/tmp
mkdir -p ${PKG_ROOT}/usr/share/doc/${PKG_NAME}

#
# Fix file modes
#
find ${PKG_ROOT} -type d -exec chmod 0755 {} \;
find ${PKG_ROOT} -type f -exec chmod 0644 {} \;
chmod 0755 ${PKG_ROOT}/opt/rport-guacamole/sbin/guacd

if stat ${PKG_ROOT}/opt/rport-guacamole/sbin/guacd|grep "Access.*0755";then
    true
else
    echo "File permission not set"
    ls -la ${PKG_ROOT}/opt/rport-guacamole/sbin/
    ls -la ${PKG_ROOT}/opt/rport-guacamole/lib/
    false
fi

find ${PKG_ROOT} -type f -name "*.la" -exec rm {} \;
find ${PKG_ROOT} -type f -name "*.so*" -exec strip {} \;
strip ${PKG_ROOT}/opt/rport-guacamole/sbin/guacd
#
# Create a systemd service file
#
cat << EOF > ${PKG_ROOT}/lib/systemd/system/rport-guacd.service
[Unit]
Description=Guacamole proxy daemon (guacd) for the rport.
ConditionFileIsExecutable=/opt/rport-guacamole/sbin/guacd

[Service]
Environment=HOME=/opt/rport-guacamole/tmp
Environment=LD_LIBRARY_PATH=/opt/rport-guacamole/lib
EnvironmentFile=/etc/default/rport-guacamole
ExecStart=/opt/rport-guacamole/sbin/guacd -f -b \${RPORT_GUACD_BIND} -l \${RPORT_GUACD_PORT}
User=daemon
Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target
EOF
chmod 0644 ${PKG_ROOT}/lib/systemd/system/rport-guacd.service

cat << EOF > ${PKG_ROOT}/etc/default/rport-guacamole
#
# Environment read by rport-guacd.service
#

# TCP Port used by the guacd
RPORT_GUACD_PORT=9445

# IP address used to bind the guacd
RPORT_GUACD_BIND=127.0.0.1

EOF
chmod 0644 ${PKG_ROOT}/etc/default/rport-guacamole

INSTALLED_SIZE=$(du -sb ${PKG_ROOT}/|awk '{print $1}')

#
# Create package meta data
#
. /etc/os-release
if [ $ID = "ubuntu" ];then 
    # Ubuntu package name
    LIB_JPEG="libjpeg-turbo8"
else
    # Debian package name
    LIB_JPEG="libjpeg62-turbo"
fi

case $(uname -m) in 
    x86_64)
        ARCH='amd64'
        ;;
    armvl7)
        ARCH='armhf'
        ;;
    aarch64)
        ARCH='arm64'
        ;;
esac
echo "ARCH = ${ARCH}"

GUACA_VERSION="1.4.0"
mkdir ${PKG_ROOT}/DEBIAN
chmod 0755 ${PKG_ROOT}/DEBIAN

#
# Create the package control file
#
cat << EOF > ${PKG_ROOT}/DEBIAN/control
Package: rport-guacamole
Version: ${GUACA_VERSION}
Maintainer: cloudradar GmbH <info@cloudradar.io>
Depends: libc6, systemd, libcairo2, ${LIB_JPEG}, libpng16-16, libwebp6, libfreerdp-client2-2, libssh2-1
Installed-Size: ${INSTALLED_SIZE}
Architecture: ${ARCH}
Section: misc
Priority: optional
Homepage: https://bitbucket.org/cloudradar/rport-guacamole/src/main/
Description: Guacamole proxy daemon (guacd) for the rport server daemon
 This version of guacd is intented to be used with rportd only.
 The only configuration file is /etc/default/rport-guacamole.
EOF

#
# List of config files
#
cat << EOF > ${PKG_ROOT}/DEBIAN/conffiles
/etc/default/rport-guacamole
EOF

#
# Create a changelog, even dummy
#
cat << EOF |gzip -n --best -c > ${PKG_ROOT}/usr/share/doc/${PKG_NAME}/changelog.gz
rport-guacamole; urgency=low

  * Non-maintainer upload.
EOF
chmod 0644 ${PKG_ROOT}/usr/share/doc/${PKG_NAME}/changelog.gz

cat << EOF > ${PKG_ROOT}/usr/share/doc/${PKG_NAME}/copyright
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Source: https://apache.org/dyn/closer.lua/guacamole/
Copyright: 2022
License: Apache-2

Files: *
Copyright: 2022
License:  Apache-2
EOF
chmod 0644 ${PKG_ROOT}/usr/share/doc/${PKG_NAME}/copyright

#
# Create a postinst script
#
cat << EOF >${PKG_ROOT}/DEBIAN/postinst
#!/bin/sh
set -e
chown daemon:daemon /opt/rport-guacamole/tmp
chmod 0755 /opt/rport-guacamole/sbin/guacd
systemctl daemon-reload
deb-systemd-invoke enable rport-guacd.service
deb-systemd-invoke start rport-guacd.service
EOF
chmod 0555 ${PKG_ROOT}/DEBIAN/postinst

#find /opt/rport-guacamole/ -type d -exec chmod 0755 {} \;
#find /opt/rport-guacamole/ -type f -exec chmod 0644 {} \;

#
# Create a prerm script
#
cat << EOF >${PKG_ROOT}/DEBIAN/prerm
#!/bin/sh
set -e
deb-systemd-invoke stop rport-guacd.service
deb-systemd-invoke disable rport-guacd.service
rm -rf /opt/rport-guacamole/tmp
EOF
chmod 0555 ${PKG_ROOT}/DEBIAN/prerm

#
# Create a postrm script
#
cat << EOF >${PKG_ROOT}/DEBIAN/postrm
#!/bin/sh
set -e
test -e /opt||mkdir /opt
EOF
chmod 0555 ${PKG_ROOT}/DEBIAN/postrm

#
# Build the debian package
#
. /etc/os-release
PKG_FILE=${PKG_NAME}_${GUACA_VERSION}_${ID}_${VERSION_CODENAME}_$(uname -m).deb
cd /
dpkg-deb -v --build ${PKG_ROOT}
mv ${PKG_ROOT}.deb /${PKG_FILE}
echo "Created $PKG_NAME in $PKG_FILE"

## Check the content of the package
dpkg-deb -c /${PKG_FILE}
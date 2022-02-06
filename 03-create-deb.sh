#
# Create folder structure
#
PKG_ROOT=/pkg
test -e $PKG_ROOT && rm -rf $PKG_ROOT
mkdir -p ${PKG_ROOT}/opt
mv /opt/rport-guacamole ${PKG_ROOT}/opt
mkdir -p ${PKG_ROOT}/lib/systemd/system

#
# Create a systemd service file
#
cat << EOF > ${PKG_ROOT}/lib/systemd/system/rport-guacd.service
[Unit]
Description=Guacamole server for rportd.
ConditionFileIsExecutable=/opt/rport-guacamole/sbin/guacd

[Service]
StartLimitInterval=5
StartLimitBurst=10
ExecStart=/opt/rport-guacamole/sbin/guacd -f -b 127.0.0.1 -l 9445
LimitNOFILE=1048576
User=daemon
Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target
EOF

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
GUACA_VERSION="1.4.0"
mkdir ${PKG_ROOT}/DEBIAN
chmod 0755 ${PKG_ROOT}/DEBIAN
cat << EOF > ${PKG_ROOT}/DEBIAN/control
Package: rport-guacamole
Version: ${GUACA_VERSION}
Maintainer: cloudradar GmbH <info@cloudradar.io>
Depends: systemd, libcairo2, ${LIB_JPEG}, libpng16-16, libwebp6
Installed-Size: ${INSTALLED_SIZE}
Architecture: amd64
Homepage: https://bitbucket.org/cloudradar/rport-guacamole/src/main/
Description: guacamole server for the rportd 
 This version of the guacamole server is intented to be used with rportd only.
EOF

#
# Create a postinst script
#
cat << EOF >${PKG_ROOT}/DEBIAN/postinst
#!/bin/sh
systemctl daemon-reload
systemctl start rport-guacd.service
systemctl enable rport-guacd.service
EOF
chmod 0555 ${PKG_ROOT}/DEBIAN/postinst

#
# Create a prerm script
#
cat << EOF >${PKG_ROOT}/DEBIAN/prerm
#!/bin/sh
systemctl stop rport-guacd.service
systemctl disable rport-guacd.service
EOF
chmod 0555 ${PKG_ROOT}/DEBIAN/prerm

#
# Build the debian package
#
. /etc/os-release
PKG_NAME=rport-guacamole_${GUACA_VERSION}_${ID}_${VERSION_CODENAME}_amd64.deb
cd /
dpkg-deb -v --build ${PKG_ROOT}
mv ${PKG_ROOT}.deb /${PKG_NAME}

## Check the content of the package
dpkg-deb -c /${PKG_NAME}
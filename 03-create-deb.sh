#
# Create folder structure
#
PKG_ROOT=/pkg
test -e $PKG_ROOT && rm -rf $PKG_ROOT
mkdir -p ${PKG_ROOT}/opt
mv /opt/rport-guacamole ${PKG_ROOT}/opt
mkdir -p ${PKG_ROOT}/lib/systemd/system
mkdir -p ${PKG_ROOT}/etc/default/
mkdir -p ${PKG_ROOT}/tmp

#
# /etc/ld.so.conf.d/rport-guacd.conf
# /opt/rport-guacamole/lib

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
Description: Guacamole proxy daemon (guacd) for the rport server daemon
 This version of the guacamole server is intented to be used with rportd only.
 The only configuration file is /etc/default/rport-guacamole
EOF

#
# Create a postinst script
#
cat << EOF >${PKG_ROOT}/DEBIAN/postinst
#!/bin/sh
chown daemon:daemon /opt/rport-guacamole/tmp
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
PKG_NAME=rport-guacamole_${GUACA_VERSION}_${ID}_${VERSION_CODENAME}_$(uname -m).deb
cd /
dpkg-deb -v --build ${PKG_ROOT}
mv ${PKG_ROOT}.deb /${PKG_NAME}
echo "Created $PKG_NAME"

## Check the content of the package
dpkg-deb -c /${PKG_NAME}
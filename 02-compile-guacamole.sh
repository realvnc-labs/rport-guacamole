#
# Download and build
#
set -e
cd /tmp
rm -rf guacamole-server*||true
GUACA_VERSION="1.5.0"
CHECK_SUM="c6c09e4056f1edd88a3c425ef05043ff835da5c1c92348bbdbf5a99e512f5fd4  guacamole-server-1.5.0.tar.gz"
curl -L "https://apache.org/dyn/closer.lua/guacamole/${GUACA_VERSION}/source/guacamole-server-${GUACA_VERSION}.tar.gz?action=download" \
-o guacamole-server-${GUACA_VERSION}.tar.gz
if [ "$(sha256sum guacamole-server-${GUACA_VERSION}.tar.gz)" = "$CHECK_SUM" ];then 
    echo "Checksum valid"
else
    echo "Checksum of download invalid. Aborting"
    exit 1
fi
tar xzf guacamole-server-${GUACA_VERSION}.tar.gz
cd guacamole-server-${GUACA_VERSION}

. /etc/os-release
if [ $VERSION_CODENAME = 'buster' ];then
    CONFIGURE_EXTRA='--enable-allow-freerdp-snapshots'
else
    CONFIGURE_EXTRA=''
fi

./configure \
--prefix=/opt/rport-guacamole \
--disable-kubernetes \
--enable-static \
--disable-guaclog \
--with-freerdp-plugin-dir=/opt/rport-guacamole/lib/freerdp2 \
--disable-telnet $CONFIGURE_EXTRA

make
make install
LD_LIBRARY_PATH=/opt/rport-guacamole/lib /opt/rport-guacamole/sbin/guacd -v
find /opt
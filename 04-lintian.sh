set -e
DEBIAN_FRONTEND=noninteractive apt-get -y install lintian >/dev/null
cd /
DEB_FILE=$(ls rport-guacamole_*.deb)
echo "Lintian for $DEB_FILE"
. /etc/os-release
case $VERSION_CODENAME in
    bullseye)
        lintian -X files/hierarchy/standard $DEB_FILE
        ;;
    focal)
        lintian -X files/hierarchy-standard $DEB_FILE
        ;;
esac

#
# Test if the package installs
#
export DEBIAN_FRONTEND=noninteractive 
apt-get -y install ./${DEB_FILE}
dpkg -l|grep guacd
service rport-guacd status
apt-get -y remove --purge rport-guacamole

echo "======================================================================================================"
echo ""
echo "  Successfully tested debian package"
echo ""
echo "======================================================================================================"

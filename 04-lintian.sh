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
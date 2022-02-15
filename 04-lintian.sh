DEBIAN_FRONTEND=noninteractive apt-get -y install lintian >/dev/null
. /etc/os-release
DEB_FILE=/rport-guacamole_1.4.0_debian_bullseye_amd64.deb
case $VERSION_CODENAME in
    bullseye)
        lintian -X files/hierarchy/standard $DEB_FILE
        ;;
    focal)
        lintian -X files/hierarchy-standard $DEB_FILE
        ;;
esac
#
# Resolve depenencies on Debian Bullseye or Ubuntu Focal
#
set -e
apt-get -y update
cat /etc/os-release
. /etc/os-release
if [ $ID = "ubuntu" ];then 
    # Ubuntu package name
    LIB_JPEG="libjpeg-turbo8-dev"
else
    # Debian package name
    LIB_JPEG="libjpeg62-turbo-dev"
fi
if [ $VERSION_CODENAME = "bionic" ];then
    EXTRA_PKGS="libossp-uuid-dev"
else
    EXTRA_PKGS=''
fi
export DEBIAN_FRONTEND=noninteractive 
apt-get -y dist-upgrade
apt-get -y install jq libtool-bin make curl libuuid1 \
 libcairo2-dev libpng-dev \
 libavcodec-dev libavformat-dev libavutil-dev \
 freerdp2-dev libpango1.0-dev libssh2-1-dev libtelnet-dev \
 libvncserver-dev libpulse-dev libssl-dev \
 libvorbis-dev libwebp-dev libwebsockets-dev ${LIB_JPEG} ${EXTRA_PKGS}

echo "=============================================================================="
echo ""
echo "  Finished resolving dependencies"
echo ""
echo "=============================================================================="

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
DEBIAN_FRONTEND=noninteractive sudo apt-get -y install ${LIB_JPEG} libcairo2-dev libpng-dev libtool-bin \
 libavcodec-dev libavformat-dev libavutil-dev \
 freerdp2-dev libpango1.0-dev libssh2-1-dev libtelnet-dev \
 libvncserver-dev libpulse-dev libssl-dev libuuid1 \
 libvorbis-dev libwebp-dev libwebsockets-dev make curl ${EXTRA_PKGS}
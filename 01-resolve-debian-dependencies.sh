#
# Resolve depenencies on Debian Bullseye
#
set -e
apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin \
 libavcodec-dev libavformat-dev libavutil-dev \
 freerdp2-dev libpango1.0-dev libssh2-1-dev libtelnet-dev \
 libvncserver-dev libpulse-dev libssl-dev \
 libvorbis-dev libwebp-dev libwebsockets-dev make curl
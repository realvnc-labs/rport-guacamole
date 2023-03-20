set -e
VERSION=1.5.0
cd /
ls -lah
FILE=$(ls rport-guacamole_*.deb)
ls -l ${UPLOAD}

# Get the release id of the tag
RELEASE_ID=$(curl --fail -Ss https://api.github.com/repos/realvnc-labs/rport-guacamole/releases/tags/${VERSION} 2>&1|jq .id)

curl -v -s --fail \
   -T ${FILE} \
   -H "Authorization: token ${GITHUB_TOKEN}" \
   -H "Content-Type: $(file -b --mime-type ${FILE})" \
   -H "Accept: application/vnd.github.v3+json" \
   "https://uploads.github.com/repos/cloudradar-monitoring/rport/releases/${RELEASE_ID}/assets?name=$(basename ${FILE})
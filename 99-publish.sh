#!/usr/bin/env bash
set -e
VERSION=1.5.0
cd /
ls -lah
FILE=$(ls rport-guacamole_*.deb)
ls -l "${FILE}"

# Get the release id of the tag
RELEASE_ID=$(curl --fail -Ss https://api.github.com/repos/realvnc-labs/rport-guacamole/releases/tags/${VERSION} 2>&1 | jq .id)

if [ -z "$LC_GITHUB_TOKEN" ]; then
    echo "LC_GITHUB_TOKEN not set."
    echo "set locally and use 'ssh -o SendEnv=LC_GITHUB_TOKEN'"
    false
fi

curl -v -s --fail \
    -T "${FILE}" \
    -H "Authorization: token ${LC_GITHUB_TOKEN}" \
    -H "Content-Type: $(file -b --mime-type ${FILE})" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://uploads.github.com/repos/realvnc-labs/rport-guacamole/releases/${RELEASE_ID}/assets?name=$(basename ${FILE})"
echo ""

echo "======================================================================================================"
echo ""
echo "  Successfully published package on GitHub"
echo ""
echo "======================================================================================================"

set -e
set -x
cd /
ls -lah
UPLOAD=$(ls rport-guacamole_*amd64.deb)
ls -l ${UPLOAD}
curl -f -u ${BITBUCKET_USERNAME}:${BITBUCKET_APP_PASSWORD} \
"https://api.bitbucket.org/2.0/repositories/${BITBUCKET_REPO_OWNER}/${BITBUCKET_REPO_SLUG}/downloads" \
-F files=@${UPLOAD}
sha256sum ${UPLOAD} > ${UPLOAD}.sha256
curl -f -u ${BITBUCKET_USERNAME}:${BITBUCKET_APP_PASSWORD} \
"https://api.bitbucket.org/2.0/repositories/${BITBUCKET_REPO_OWNER}/${BITBUCKET_REPO_SLUG}/downloads" \
-F files=@${UPLOAD}.sha256
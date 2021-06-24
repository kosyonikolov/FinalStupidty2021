#!/usr/bin/env bash
#
# This script accepts the following parameters:
#
# * owner
# * repo
# * tag
# * filename
#
# Script to upload a release asset using the GitHub API v3.
#
# Example:
#
# GITHUB_API_TOKEN=api-token ./upload_github_rel.sh owner=kosyonikolov repo=FinalStupidty2021 tag=v0.0.19 filename=./build.zip
#

# Check dependencies.
set -e
xargs=$(which gxargs || which xargs)

# Validate settings.
[ "$TRACE" ] && set -euo

CONFIG=$@

for line in $CONFIG; do
  eval "$line"
done

# Define variables.
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$owner/$repo"
AUTH="Authorization: token $GITHUB_API_TOKEN"

curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

echo "Creating release ${tag}..."

RESPONSE=$(curl -X POST -H "${AUTH}" -H "Accept: application/vnd.github.v3+json" "${GH_REPO}/releases" -d "{\"tag_name\":\"${tag}\", \"name\": \"My first release\"}")
ID="$(echo "${RESPONSE}" | jq '.id')"

echo "Release created..."
echo "Uploading asset ${filename}... "

RESPONSE=$(curl \
    -H "${AUTH}" \
    -H "Content-Type: $(file -b --mime-type $filename)" \
    --data-binary @$filename \
    "https://uploads.github.com/repos/${owner}/${repo}/releases/${ID}/assets?name=$(basename $filename)")

echo "Asset successfully uploaded"
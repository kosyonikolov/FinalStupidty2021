#!/usr/bin/env bash
#
# Script to upload build all latex files using docker, create a release and upload the build artifacts zipped as an asset using the GitHub API v3.
#
# Example:
#
# GITHUB_API_TOKEN=api-token ./release.sh tag=vx.x.x
#

# Check dependencies.
set -e
xargs=$(which gxargs || which xargs)

# Validate settings.
[ "$TRACE" ] && set -euo pipefail

CONFIG=$@

for line in $CONFIG; do
  eval "$line"
done

readonly Y="\033[1;33m"
readonly G="\033[0;32m"
readonly W="\033[0m"

readonly IMAGE=blang/latex:ubuntu
readonly BUNDLE_PATH="${PROJECT_ROOT}/bundle"
readonly BUNDLE_ZIP_NAME='bundle.zip'
readonly BUNDLE_ZIP_PATH="${PROJECT_ROOT}/bundle.zip"

readonly OWNER="kosyonikolov"
readonly REPO="FinalStupidty2021"
readonly GH_API="https://api.github.com"
readonly GH_UPLOADS="https://uploads.github.com"

run_docker_latex(){
    docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "${PROJECT_ROOT}":/data "${IMAGE}" "$@"
}

build_bundle() {
    local pdf_name topic_id qualified_pdf_name

    pushd "${PROJECT_ROOT}" &> /dev/null

    echo -e "${Y}Began build...${W}"

    mkdir -p "${BUNDLE_PATH}"
    run_docker_latex /bin/bash -c "while read -r tex_file_path; do echo \"Building \${tex_file_path}...\"; pushd \"\$(dirname \$tex_file_path)\" &> /dev/null; latexmk -pdf \$tex_file_path &> build.log; latexmk -c &> /dev/null; popd &> /dev/null; done< <(find /data | grep -E '^/data/[0-9]+/.*\.tex$')" || echo $?

    echo -e "${Y}Bundling sources...${W}"

    while read -r pdf_file_path; do
        pdf_name="$(basename ${pdf_file_path})"
        topic_id="$(echo ${pdf_file_path} | sed 's/.*\/\([0-9]*\)\/.*\.pdf/\1/g')"

        qualified_pdf_name="${topic_id}_${pdf_name}"

        cp "${pdf_file_path}" "${BUNDLE_PATH}/${qualified_pdf_name}"

    done < <(find "${PROJECT_ROOT}" | grep -E '.*/[0-9]+/.*\.pdf$')

    echo -e "${Y}Zipping it all up...${W}"

    rm -f "${BUNDLE_ZIP_NAME}"
    zip -r "${BUNDLE_ZIP_NAME}" bundle
    rm -rf "${BUNDLE_PATH}"

    popd &> /dev/null
}

create_release() {
    local repo_path auth_header response rel_id

    repo_path="/repos/${OWNER}/${REPO}"
    auth_header="Authorization: token ${GITHUB_API_TOKEN}"

    echo -e "${Y}Checking repo and token validity...${W}"

    curl -o /dev/null -sH "${auth_header}" "${GH_API}${repo_path}" || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

    echo -e "${Y}Creating release ${tag}...${W}"

    response=$(curl -X POST -H "${auth_header}" -H "Accept: application/vnd.github.v3+json" "${GH_API}${repo_path}/releases" -d "{\"tag_name\":\"${tag}\", \"name\": \"${tag}\"}")
    rel_id="$(echo "${response}" | jq '.id')"

    echo -e "${G}Release created${W}"
    echo -e "${Y}Uploading asset ${BUNDLE_ZIP_PATH}...${W}"

    response=$(curl \
        -H "${auth_header}" \
        -H "Content-Type: $(file -b --mime-type "${BUNDLE_ZIP_PATH}")" \
        --data-binary @"${BUNDLE_ZIP_PATH}" \
        "${GH_UPLOADS}${repo_path}/releases/${rel_id}/assets?name=$(basename "${BUNDLE_ZIP_PATH}")")

    echo -e "${G}Asset successfully uploaded${W}"
}

build_bundle
create_release

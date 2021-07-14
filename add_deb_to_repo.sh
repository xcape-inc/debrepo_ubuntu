#!/bin/bash
set -e
trap 'catch $? $LINENO' ERR
catch() {
  echo "Error $1 occurred on $2"
}
PARAMS=$1
if [[ "${PARAMS}" == '' ]]; then
  echo 'Script requires parameters'; false
fi
set -euo pipefail
PARAMS=("$@")
TARGET_FILE_PATH="${PARAMS[0]}"
DISTRO_RELEASE_CODENAME="${DISTRO_RELEASE_CODENAME:-focal}"

sha256sum "${TARGET_FILE_PATH}"
(dpkg -I "${TARGET_FILE_PATH}" | grep '^ Section:') && PACKAGE_HAS_SECTION=1 || PACKAGE_HAS_SECTION=0

# allows the package to default to utils if no section defined in deb
if [[ "${TARGET_FILE_PATH}" == "1" ]]; then
  reprepro --outdir ./REPOSITORY.PATH includedeb "${DISTRO_RELEASE_CODENAME}" "${TARGET_FILE_PATH}"
else
  reprepro -S utils --outdir ./REPOSITORY.PATH includedeb "${DISTRO_RELEASE_CODENAME}" "${TARGET_FILE_PATH}"
fi
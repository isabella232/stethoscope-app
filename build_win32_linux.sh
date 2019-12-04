#!/bin/bash
set -euo pipefail

docker build . -t builder-wine-steth
docker run --rm -ti \
  --env-file <(env | grep -iE 'DEBUG|NODE_|ELECTRON_|YARN_|NPM_|CI|BT_|AWS_|STRIP|BUILD_') \
  --env ELECTRON_CACHE='/root/.cache/electron' \
  --env ELECTRON_BUILDER_CACHE='/root/.cache/electron-builder' \
  -v "${PWD}/dist":/project/dist \
  builder-wine-steth bash -c 'yarn electron-builder -wl'
perl -pi -e 's/Stethoscope Setup /Stethoscope-Setup-/g' dist/latest.yml && \
  for file in dist/*.exe; do
    [ -f "$file" ] && ( mv "$file" "$(echo "$file" | sed -e 's/ /-/g')" )
  done

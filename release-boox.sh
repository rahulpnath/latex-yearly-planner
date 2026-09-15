#!/usr/bin/env bash
# Builds every variant for one year into dist/<device>/<surface>/.
#
#   ./release-boox.sh 2026
#
# device x surface (dot grid / ruled lines) x layout (schedule on the day page
# / time blocking) = eight PDFs per year.

set -eo pipefail

YEAR=${1:-$(date +%Y)}
BASE="cfg/base.yaml,cfg/boox_go_103.base.yaml,cfg/template_breadcrumb.yaml,cfg/boox_go_103.breadcrumb.custom.yaml"
LINED="cfg/boox_go_103.lined.yaml"
TIMEBLOCK="cfg/boox_go_103.timeblock.yaml"

build() {
  local device=$1 surface=$2 cfg=$3 name="eink-planner-${YEAR}${4}"

  mkdir -p "dist/${device}/${surface}"
  echo "building dist/${device}/${surface}/${name}.pdf"
  docker compose run --rm -e PLANNER_YEAR="${YEAR}" -e CFG="${cfg}" -e NAME="${name}" planner >/dev/null </dev/null
  mv "${name}.pdf" "dist/${device}/${surface}/${name}.pdf"
}

# device folder, and the overlay that adapts the page to it ("" for none)
while read -r device overlay; do
  suffix=""; [ -n "${overlay}" ] && suffix=",${overlay}"
  build "${device}" dotted "${BASE}${suffix}"                            ""
  build "${device}" dotted "${BASE},${TIMEBLOCK}${suffix}"               "-timeblock"
  build "${device}" lined  "${BASE},${LINED}${suffix}"                   ""
  build "${device}" lined  "${BASE},${LINED},${TIMEBLOCK}${suffix}"      "-timeblock"
done <<'DEVICES'
10-inch-eink
remarkable-2 cfg/device_rm2_toolbar.yaml
DEVICES

rm -rf out/*

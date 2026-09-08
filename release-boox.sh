#!/usr/bin/env bash
# Builds every Boox Go 10.3 variant for one year into dist/<surface>/.
#
#   ./release-boox.sh 2026
#
# Surface (dot grid / ruled lines) x layout (schedule on the day page / time
# blocking) = four PDFs per year.

set -eo pipefail

YEAR=${1:-$(date +%Y)}
BASE="cfg/base.yaml,cfg/boox_go_103.base.yaml,cfg/template_breadcrumb.yaml,cfg/boox_go_103.breadcrumb.custom.yaml"
LINED="cfg/boox_go_103.lined.yaml"
TIMEBLOCK="cfg/boox_go_103.timeblock.yaml"

build() {
  local surface=$1 layout=$2 cfg=$3 name="boox-go-10.3-planner-${YEAR}${4}"

  mkdir -p "dist/${surface}"
  echo "building dist/${surface}/${name}.pdf"
  docker compose run --rm -e PLANNER_YEAR="${YEAR}" -e CFG="${cfg}" -e NAME="${name}" planner >/dev/null
  mv "${name}.pdf" "dist/${surface}/${name}.pdf"
}

build dotted standard  "${BASE}"                              ""
build dotted timeblock "${BASE},${TIMEBLOCK}"                 "-timeblock"
build lined  standard  "${BASE},${LINED}"                     ""
build lined  timeblock "${BASE},${LINED},${TIMEBLOCK}"        "-timeblock"

rm -rf out/*

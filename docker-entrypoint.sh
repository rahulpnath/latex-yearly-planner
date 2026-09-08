#!/usr/bin/env bash
#
# Default command for the planner image.
#
# Every knob is an environment variable, so a build is one `docker run`:
#
#   docker run --rm -v "$PWD:/out" -e PLANNER_YEAR=2027 latex-yearly-planner
#
# Defaults reproduce the Boox Go 10.3 build described in the README.

set -eo pipefail

: "${PLANNER_YEAR:=$(date +%Y)}"
: "${PASSES:=2}"
: "${CFG:=cfg/base.yaml,cfg/boox_go_103.base.yaml,cfg/template_breadcrumb.yaml,cfg/boox_go_103.breadcrumb.custom.yaml}"
: "${NAME:=boox_go_103.${PLANNER_YEAR}}"
: "${OUTDIR:=/out}"

export PLANNER_YEAR PASSES CFG NAME

echo "building ${NAME}.pdf for ${PLANNER_YEAR}"
echo "  config: ${CFG}"

./single.sh

# When /out is mounted, drop the finished PDF there. When the repo itself is
# bind-mounted over /planner (the docker-compose flow) there is no /out and the
# PDF simply stays in the repo, next to single.sh.
if [ -d "${OUTDIR}" ]; then
  cp "${NAME}.pdf" "${OUTDIR}/"
  echo "wrote ${OUTDIR}/${NAME}.pdf"
fi

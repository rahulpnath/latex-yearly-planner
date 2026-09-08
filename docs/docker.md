# Building with Docker

Building a planner needs two toolchains that are irritating to install side by
side: Go, which renders `cfg/*.yaml` + `tpls/*.tpl` into LaTeX, and XeLaTeX with
a specific set of packages, which turns that LaTeX into a PDF. The Docker files
here pin both, so the only thing you need on your machine is Docker.

| File | Why it's here |
| --- | --- |
| `Dockerfile` | Go 1.22 plus XeLaTeX and the exact TeX packages the templates use — `extsizes` (the `extarticle` class), `adjustbox`, `multido` (draws the dot grids), `marginnote`, `pgf`/`tikz`, `leading`, `makecell`, `varwidth`, `dashrule` — and `python3`, `ps` and `rev`, which the build scripts shell out to. The repo is **copied into** the image, not just mounted, so the image can build a planner on its own. |
| `docker-entrypoint.sh` | Turns the `PLANNER_YEAR` / `CFG` / `NAME` / `PASSES` variables `single.sh` expects into a plain `docker run`, and copies the finished PDF to `/out`. |
| `docker-compose.yml` | Bind-mounts the repo over `/planner` for the edit-a-config-and-rebuild loop. Runs as your UID so generated files aren't owned by root. |
| `.dockerignore` | Keeps `.git`, `out/` and `*.pdf` out of the build context. |

### Without cloning the repo

`docker build` takes a git URL as its build context, so Docker does the
checkout for you:

```bash
docker build -t planner https://github.com/rahulpnath/latex-yearly-planner.git
docker run --rm -v "$PWD:/out" planner
```

The PDF lands in the current directory. Nothing is installed on the host and no
copy of the repo is left behind.

> The git URL must point at a repo that **contains these Docker files** — this
> fork, or a branch of it. Upstream does not have them.

Pick a year, a device, a layout — every knob is an environment variable:

```bash
docker run --rm -v "$PWD:/out" \
  -e PLANNER_YEAR=2027 \
  -e PASSES=2 \
  -e CFG="cfg/base.yaml,cfg/template_months_on_side.yaml,cfg/sn_a5x.mos.default.yaml" \
  -e NAME="sn_a5x.mos.default.2027" \
  planner
```

| Variable | Default | Meaning |
| --- | --- | --- |
| `PLANNER_YEAR` | current year | Year to generate |
| `CFG` | the [Boox Go 10.3 preset](boox-go-103.md) | Comma-separated config chain, applied left to right |
| `NAME` | `boox_go_103.<year>` | Output filename, without `.pdf` |
| `PASSES` | `2` | XeLaTeX runs. Keep at 2 — one pass leaves the PDF outline and internal links stale |
| `OUTDIR` | `/out` | Where the PDF is copied, if the directory exists |

### With the repo cloned

For editing configs and rebuilding, `docker compose` bind-mounts the repo so
changes to `cfg/` and `tpls/` take effect with no image rebuild:

```bash
docker compose build                              # once, ~90s
docker compose run --rm planner                   # PDF appears in the repo
docker compose run --rm -e PLANNER_YEAR=2027 planner
```

To run one of the other scripts in the same environment, override the
entrypoint:

```bash
docker compose run --rm --entrypoint ./build.sh planner 2027
```

The image is ~2.5GB unpacked, nearly all of it TeX Live.

For what to put in `CFG`, see [the Boox Go 10.3 preset](boox-go-103.md).

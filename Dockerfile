# Self-contained build environment for latex-yearly-planner.
#
# The project needs two toolchains that are awkward to install side by side:
# Go (to render cfg/*.yaml + tpls/*.tpl into LaTeX) and XeLaTeX with a specific
# set of packages (to turn that LaTeX into a PDF). This image pins both, so
# building a planner needs nothing on the host but Docker.
#
# The repo is copied in, not just mounted, so the image can build a planner on
# its own:
#
#   docker build -t latex-yearly-planner https://github.com/<you>/latex-yearly-planner.git
#   docker run --rm -v "$PWD:/out" latex-yearly-planner
#
# docker-compose.yml bind-mounts the repo over /planner instead, for editing
# configs and rebuilding without touching the image.
FROM golang:1.22-bookworm

# texlive-xetex            - single.sh renders with xelatex, not pdflatex
# texlive-latex-extra      - extsizes (the extarticle class), adjustbox, leading,
#                            makecell, marginnote, varwidth, wrapfig, dashrule,
#                            blindtext, showframe
# texlive-latex-recommended- geometry, hyperref, setspace, multirow, tabularx
# texlive-pictures         - pgf/tikz
# texlive-pstricks         - multido, which draws the dot grids
# texlive-fonts-recommended- the fonts the above pull in
# texlive-plain-generic    - assorted .sty files the extras depend on
# python3                  - parser.py (build progress), translate.py
# procps / util-linux      - build.sh uses `ps`, single.sh uses `rev`
RUN apt-get update && apt-get install -y --no-install-recommends \
        texlive-xetex \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-pictures \
        texlive-fonts-recommended \
        texlive-plain-generic \
        texlive-pstricks \
        python3 \
        procps \
        util-linux \
        bash \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /planner

# Module download is its own layer so editing configs or templates does not
# re-fetch dependencies. It also means a planner build needs no network.
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Any UID must be able to write out/ and the finished PDF, because runs pass
# --user to keep generated files owned by the caller rather than root.
RUN mkdir -p out && chmod -R a+w /planner

ENV HOME=/tmp \
    GOCACHE=/tmp/.gocache \
    GOMODCACHE=/go/pkg/mod \
    GOFLAGS=-mod=mod \
    TEXMFVAR=/tmp/.texmf-var \
    TEXMFCONFIG=/tmp/.texmf-config \
    TEXMFHOME=/tmp/.texmf

ENTRYPOINT ["./docker-entrypoint.sh"]

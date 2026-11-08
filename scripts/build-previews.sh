#!/bin/bash
# Compile the examples and design previews, and render the README images.
# Needs a TeX distribution with latexmk (TeX Live or MacTeX) and pdftoppm (poppler).
# Run from anywhere:  scripts/build-previews.sh
set -euo pipefail
cd "$(dirname "$0")/.."
IMG=docs/images
mkdir -p "$IMG"

# examples in the repository root
latexmk -pdf -interaction=nonstopmode -silent example-omicverse.tex
latexmk -pdf -interaction=nonstopmode -silent example-primordecode.tex
latexmk -pdf -interaction=nonstopmode -silent template.tex
latexmk -xelatex -interaction=nonstopmode -silent example-zh.tex

# one file per page design / option, written to previews/
for f in previews/*.tex; do
  latexmk -pdf -interaction=nonstopmode -silent -outdir=previews "$f"
done

# page images for the README (900 px wide)
png() { pdftoppm -png -singlefile -f "$2" -l "$2" -scale-to-x 900 -scale-to-y -1 "$1" "$IMG/$3"; }
png previews/omicverse-rail.pdf        1 omicverse-rail-p1
png previews/omicverse-rail.pdf        2 omicverse-rail-p2
png previews/omicverse-masthead.pdf    1 omicverse-masthead-p1
png previews/omicverse-panel.pdf       1 omicverse-panel-p1
png previews/omicverse-twocolumn.pdf   1 omicverse-twocolumn-p1
png previews/omicverse-twocolumn.pdf   2 omicverse-twocolumn-p2
png previews/omicverse-lineno.pdf      2 omicverse-lineno-p2
png previews/primordecode-rail.pdf     1 primordecode-rail-p1
png example-zh.pdf                     1 zh-p1
echo "images written to $IMG/"

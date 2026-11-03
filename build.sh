#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

if ! command -v pdflatex >/dev/null 2>&1; then
    echo "Error: pdflatex is not installed. See the Fedora setup instructions in README.md." >&2
    exit 1
fi

mkdir -p build

for pass in 1 2; do
    echo "Building PDF (pass $pass/2)..."
    if ! pdflatex \
        -interaction=nonstopmode \
        -halt-on-error \
        -file-line-error \
        -output-directory=build \
        main.tex; then
        echo "Build failed. See build/main.log for details." >&2
        exit 1
    fi
done

echo "PDF created: $repo_dir/build/main.pdf"

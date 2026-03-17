#!/usr/bin/env bash
# Builds the docs site and serves it for local browsing.
# Run with: bazel run //docs:serve_docs  →  browse http://localhost:8000
set -euo pipefail

# Standard Bazel 3-way runfiles init.
if [[ -f "${RUNFILES_DIR:-/dev/null}/bazel_tools/tools/bash/runfiles/runfiles.bash" ]]; then
  # shellcheck source=/dev/null
  source "${RUNFILES_DIR}/bazel_tools/tools/bash/runfiles/runfiles.bash"
elif [[ -f "${BASH_SOURCE[0]}.runfiles/bazel_tools/tools/bash/runfiles/runfiles.bash" ]]; then
  # shellcheck source=/dev/null
  source "${BASH_SOURCE[0]}.runfiles/bazel_tools/tools/bash/runfiles/runfiles.bash"
elif [[ -f "${RUNFILES_MANIFEST_FILE:-/dev/null}" ]]; then
  # shellcheck source=/dev/null
  source "$(grep -m1 "^bazel_tools/tools/bash/runfiles/runfiles.bash " \
    "$RUNFILES_MANIFEST_FILE" | cut -d ' ' -f2-)"
else
  echo >&2 "ERROR: cannot find Bazel runfiles library"
  exit 1
fi

ZENSICAL=$(rlocation _main/docs/zensical)

# Zensical requires the config to sit at the project root with relative paths.
# The workspace designdocs files are real files (single symlink) so no cp -rL needed.
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT
ln -s "${BUILD_WORKSPACE_DIRECTORY}/designdocs" "$WORKDIR/designdocs"
sed '/^docs_dir:/d' "${BUILD_WORKSPACE_DIRECTORY}/docs/mkdocs.yml" > "$WORKDIR/mkdocs.yml"
echo "docs_dir: designdocs" >> "$WORKDIR/mkdocs.yml"

cd "$WORKDIR"
"$ZENSICAL" build --clean

# Zensical locates its theme assets via __file__ at runtime, but the Bazel
# runfiles layout differs from a regular pip install, so it silently skips
# the copy. Copy them manually from the tool's runfiles.
ZENSICAL_ASSETS=$(find "$(readlink -f "$ZENSICAL").runfiles" -path "*/zensical/templates/assets" -type d | head -1)
cp -rL "$ZENSICAL_ASSETS" "$WORKDIR/site/assets"

echo "Serving docs on http://localhost:8000"
exec python3 -m http.server 8000 --directory "$WORKDIR/site"

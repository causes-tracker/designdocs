#!/usr/bin/env bash
# Builds the docs with Zensical and deploys to GitHub Pages via ghp-import.
# Run with: bazel run //docs:deploy_docs
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
GHP_IMPORT=$(rlocation _main/docs/ghp_import)

# Use the actual workspace docs/ so git is available for the gh-pages push.
cd "${BUILD_WORKSPACE_DIRECTORY}/docs"

"$ZENSICAL" build
"$GHP_IMPORT" --force --push site

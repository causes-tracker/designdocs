#!/usr/bin/env bash
# Runs mkdocs from the correct working directory.
#
# When BUILD_WORKSPACE_DIRECTORY is set (bazel run), uses the actual workspace
# docs/ directory so git is available for gh-deploy.
# When called without BUILD_WORKSPACE_DIRECTORY (e.g. from docs_test), uses
# the runfiles docs/ directory so designdocs data deps are reachable.
#
# Default: bazel run //docs:deploy_docs  →  gh-deploy --force
# Test:    called by docs_test with explicit mkdocs args
set -euo pipefail

# Standard Bazel 3-way runfiles init — works in sh_test (RUNFILES_DIR set)
# and sh_binary/bazel-run (BASH_SOURCE[0].runfiles present).
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

MKDOCS=$(rlocation _main/docs/mkdocs)

# Use the actual workspace docs/ when running via `bazel run` so git works.
# Fall back to the runfiles docs/ when called from docs_test (no workspace).
if [[ -n "${BUILD_WORKSPACE_DIRECTORY:-}" ]]; then
  cd "$BUILD_WORKSPACE_DIRECTORY/docs"
else
  cd "$(dirname "$(rlocation _main/docs/mkdocs.yml)")"
fi

if [[ $# -eq 0 ]]; then
  exec "$MKDOCS" gh-deploy --force
else
  exec "$MKDOCS" "$@"
fi

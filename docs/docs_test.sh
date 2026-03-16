#!/usr/bin/env bash
# Smoke-tests the docs build by calling deploy_docs with mkdocs build --strict.
# By calling deploy_docs directly this test exercises the same setup logic as
# the real deploy, so regressions in deploy_docs.sh are caught before CI.
#
# Run with: bazel test //docs:docs_test
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

DEPLOY=$(rlocation _main/docs/deploy_docs)
TMPDIR_TEST=$(mktemp -d)
trap 'rm -rf "$TMPDIR_TEST"' EXIT

"$DEPLOY" build --strict --site-dir="$TMPDIR_TEST/site"

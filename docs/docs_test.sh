#!/usr/bin/env bash
# Smoke-tests the docs build by running mkdocs build --strict against the
# real content. Fails if any link is broken or the theme is misconfigured.
#
# Uses the same runfiles mechanism as deploy_docs.sh so failures here
# reproduce deploy failures before they reach CI.
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

MKDOCS=$(rlocation _main/docs/mkdocs)
MKDOCS_YML=$(rlocation _main/docs/mkdocs.yml)
TMPDIR_TEST=$(mktemp -d)
trap 'rm -rf "$TMPDIR_TEST"' EXIT

# cd to the docs runfiles dir so docs_dir: ../designdocs resolves to the
# designdocs content that was declared as a data dep.
cd "$(dirname "$MKDOCS_YML")"
"$MKDOCS" build --strict --config-file=mkdocs.yml --site-dir="$TMPDIR_TEST/site"

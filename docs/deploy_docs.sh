#!/usr/bin/env bash
# Deploys the docs site to GitHub Pages via mkdocs gh-deploy.
#
# Must be run via `bazel run //docs:deploy_docs` so that
# BUILD_WORKSPACE_DIRECTORY is set by Bazel.
set -euo pipefail

# Bazel sets BUILD_WORKSPACE_DIRECTORY to the workspace root when using
# `bazel run`. mkdocs must run from there so relative paths in mkdocs.yml
# (e.g. docs_dir: ../designdocs) resolve correctly.
# bazel-bin/ is a workspace symlink that always points to the latest outputs;
# mkdocs is guaranteed built because deploy_docs declares it as a data dep.
cd "$BUILD_WORKSPACE_DIRECTORY"

exec bazel-bin/docs/mkdocs gh-deploy --force

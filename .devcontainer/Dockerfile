FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install Python 3.12 (needed to bootstrap rules_python targets locally)
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3.12 python3-pip python3-venv git-delta \
    && rm -rf /var/lib/apt/lists/*

# Install Bazelisk as `bazel` — reads .bazelversion to pick the right Bazel version.
# Pin the Bazelisk version; update when a new release is available.
ARG BAZELISK_VERSION=1.28.1
RUN curl -fsSL \
      "https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-amd64" \
      -o /usr/local/bin/bazel \
    && chmod +x /usr/local/bin/bazel

# Install Buildifier — formatter and linter for Bazel BUILD files.
ARG BUILDIFIER_VERSION=8.5.1
RUN curl -fsSL \
      "https://github.com/bazelbuild/buildtools/releases/download/v${BUILDIFIER_VERSION}/buildifier-linux-amd64" \
      -o /usr/local/bin/buildifier \
    && chmod +x /usr/local/bin/buildifier

#!/bin/bash

set -euo pipefail

function debug() {
    echo "::debug file=${BASH_SOURCE[0]},line=${BASH_LINENO[0]}::$1"
}

function warning() {
    echo "::warning file=${BASH_SOURCE[0]},line=${BASH_LINENO[0]}::$1"
}

function error() {
    echo "::error file=${BASH_SOURCE[0]},line=${BASH_LINENO[0]}::$1"
}

function add_mask() {
    echo "::add-mask::$1"
}

if [ -z "$GITHUB_ACTOR" ]; then
    error "GITHUB_ACTOR environment variable is not set"
    exit 1
fi

if [ -z "$GITHUB_REPOSITORY" ]; then
    error "GITHUB_REPOSITORY environment variable is not set"
    exit 1
fi

if [ -z "$GH_PERSONAL_ACCESS_TOKEN" ]; then
    error "GH_PERSONAL_ACCESS_TOKEN environment variable is not set"
    exit 1
fi

add_mask "${GH_PERSONAL_ACCESS_TOKEN}"

if [ -z "${GH_PAGES_COMMIT_MESSAGE:-}" ]; then
    debug "GH_PAGES_COMMIT_MESSAGE not set, using default"
    GH_PAGES_COMMIT_MESSAGE='Automatically publish GitHub Pages'
fi

GIT_REPOSITORY_URL="https://${GH_PERSONAL_ACCESS_TOKEN}@${GITHUB_SERVER_URL#https://}/$GITHUB_REPOSITORY.git"

debug "Checking out gh-pages repository"
tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
(
#     cd "$tmp_dir" || exit 1
#     git init
#     git config user.name "$GITHUB_ACTOR"
#     git config user.email "$GITHUB_ACTOR@users.noreply.github.com"
#     git pull "$GIT_REPOSITORY_URL" gh-pages
) || exit 1

debug "Enumerating contents of $1"
cp -r "$1" "$tmp_dir"

# debug "Committing and pushing changes"
# (
#     cd "$tmp_dir" || exit 1
#     git add .
#     git commit -m "$GH_PAGES_COMMIT_MESSAGE"
#     git push --set-upstream "$GIT_REPOSITORY_URL" gh-pages
# ) || exit 1

# rm -rf "$tmp_dir"
exit 0

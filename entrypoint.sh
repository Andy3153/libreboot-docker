#!/bin/bash
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

set -e

LBMK_REPO="${LBMK_REPO:-https://codeberg.org/libreboot/lbmk.git}"
LBMK_DIR="/work/lbmk"

if [ -n "${GIT_USER_NAME:-}" ]
then
  git config --global user.name "$GIT_USER_NAME"
fi

if [ -n "${GIT_USER_EMAIL:-}" ]
then
  git config --global user.email "$GIT_USER_EMAIL"
fi

if [ -z "$(git config --global user.name || true)" ] || [ -z "$(git config --global user.email || true)" ]
then
  echo "git user.name/user.email not set; lbmk builds will fail." >&2
  echo "Set GIT_USER_NAME and GIT_USER_EMAIL in your .env file." >&2
fi

if [ ! -d "$LBMK_DIR/.git" ]
then
  echo "lbmk not found in /work, cloning $LBMK_REPO ..."
  git clone "$LBMK_REPO" "$LBMK_DIR"
fi

cd "$LBMK_DIR"
exec "$@"

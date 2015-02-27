#!/bin/sh
set -e

: ${PKG_NAME:='picons'}
: ${PPA:='vdr'}
: ${PPA_URL:='http://ppa.launchpad.net/aap'}
: ${DIR:="$(cd "$(dirname "$0")" && pwd)"}
SRC_DIR="$DIR"


[ ! -f "$HOME/.build.config" ] || . "$HOME/.build.config" && IGNORE_GLOBAL_CONFIG='true'
[ ! -f "$DIR/build.config" ]   || . "$DIR/build.config" && IGNORE_CONFIG='true'

: ${PPA_BUILDER:="$DIR/ppa-builder"}
: ${PPA_BUILDER_URL:='https://github.com/AndreyPavlenko/ppa-builder.git'}

[ -d "$PPA_BUILDER" ] || git clone "$PPA_BUILDER_URL" "$PPA_BUILDER"
. "$PPA_BUILDER/build.sh"

update() {
    echo "Update:"
}

_checkout() {
    echo "Checkout:"
    local dest="$1"
    mkdir -p "$dest"
    cp -r "$DIR/picons" "$dest"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _git_changelog "${cur_version##*~}" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

version() {
    local version="1.0.0"
    local ci_count=$(git --git-dir="$DIR/.git" log --format='%H' | wc -l)
    local sha_short=$(git --git-dir="$DIR/.git" rev-parse --short HEAD)
    echo "${version}-${ci_count}~${sha_short}"
}

_main $@

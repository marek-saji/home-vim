#!/bin/sh
set -e

cd "$( cd "$( dirname "$0" )" && pwd -P )"

PACK=saji
PACK_DIR="./pack/$PACK"

COMMAND="$1"
if [ "$#" -gt 0 ]
then
    shift
fi

help ()
{
    printf "Manage VIM plugins using vim’s packages (in %s).\n" "$PACK_DIR"
    printf "\n"
    printf "Usage:\n"
    printf "  %s add GIT_URL [NAME] [LOAD_POLICY]\n" "$0"
    printf "  %s upgrade\n" "$0"
    printf "  %s remove NAME [LOAD_POLICY]\n" "$0"
    printf "\n"
    printf "  NAME may be left empty to get it from GIT_URL\n"
    printf "  LOAD_POLICY is 'start' (default) or 'opt'\n"
}

add ()
{
    URL="$1"
    NAME="$2"
    LOAD_POLICY="${3:-start}"
    if [ -z "$NAME" ]
    then
        NAME="$( basename "$URL" .git )"
    fi
    set -x
    git submodule add "$URL" "$PACK_DIR/$LOAD_POLICY/$NAME"
    git commit -m "plugin: $NAME"
}

remove ()
{
    NAME="$1"
    LOAD_POLICY="${2:-start}"
    set -x
    git submodule deinit "$PACK_DIR/$LOAD_POLICY/$NAME"
    git rm "$PACK_DIR/$LOAD_POLICY/$NAME"
    if [ -e "$PACK_DIR/$LOAD_POLICY/$NAME" ]
    then
        trash-put "$PACK_DIR/$LOAD_POLICY/$NAME"
    fi
    git commit -m "remove plugin: $NAME"
}

upgrade ()
{
    set -x
    git submodule update --remote --merge
    git commit "$PACK_DIR" -c "Update packs"
}

case "$COMMAND" in
    add|install )
        add "$@" ;;
    rm|remove )
        remove "$@" ;;
    update|upgrade )
        upgrade "$@" ;;
    help|"" )
        help ;;
    * )
        help
        printf "\nUnknown command: '%s'.\n" "$COMMAND" 1>&2
esac

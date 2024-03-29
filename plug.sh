#!/bin/sh
set -e

cd "$( cd "$( dirname "$0" )" && pwd -P )"

PACK=saji
PACK_DIR="./pack/$PACK"


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

bash_autocomplete () # FIXME
{
    cmd="$1"
    prefix="$2"

    cmd_len="${#cmd}"
    # shellcheck disable=SC2039
    line="$( echo "$COMP_LINE" | cut -b$(( cmd_len + 1 ))- )"
    # shellcheck disable=SC2086
    set -- $line
    subcmd="$1"

    case "$subcmd" in
        "add"|"update" )
            ;;
        "remove" )
            for load_policy in start opt
            do
                find ./pack/saji/$load_policy/ \
                    -mindepth 1 -maxdepth 1 \
                    -printf "%f $load_policy\n" \
                    2>/dev/null \
                    | grep "^$prefix"
            done
            ;;
        * )
            printf "add\nupgrade\nremove\n" | grep "^$subcmd"
    esac
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
    git submodule init
    git submodule update --remote --merge
    git commit -m "Update packs" "$PACK_DIR"
}

if [ -n "$COMP_LINE" ]
then
    bash_autocomplete "$@"
    exit 0
fi

COMMAND="$1"
if [ "$#" -gt 0 ]
then
    shift
fi

case "$COMMAND" in
    add|install )
        add "$@" ;;
    rm|remove )
        remove "$@" ;;
    init|update|upgrade )
        upgrade "$@" ;;
    help|"" )
        help ;;
    * )
        help
        printf "\nUnknown command: '%s'.\n" "$COMMAND" 1>&2
esac

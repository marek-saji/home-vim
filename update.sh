#!/bin/sh
set -ex

PACK=saji

# Adding a package:
# git submodule add $URL pack/$PACK/start/$NAME # (or start→opt)
# git commit

# Removing package:
# git submodule deinit pack/$PACK/*/$NAME
# git rm pack/$PACK/*/$NAME
# trash-put pack/$PACK/*/$NAME
# git commit

git submodule update --remote --merge
git commit

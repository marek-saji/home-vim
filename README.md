~/.vim
======

1. Clone repository to ~/.vim/

2. Initialize vundle (plugin manager) submodule
   (if did not clone with `--recursive`)

        git submodule init
        git submodule update

3. Use ~/.vim/rc.vim as your ~/.vimrc
   and ~/.vim/rcgui.vim as ~/.gvimrc

   Two choices here:

   1. link it
   2. create ~/.vimrc with just `source ~/.vim/rc.vim`
      and ~/.gvimrc with `source ~/.vim/rcgui.vim`

4. Initialize plugins:

        vim +BundleInstall +qa

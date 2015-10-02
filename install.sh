git submodule init && git submodule update
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.backup
fi
echo "so ~/.vim/vimrc" > ~/.vimrc

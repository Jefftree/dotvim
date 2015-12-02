git submodule init && git submodule update
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.backup
fi
echo "so ~/.vim/vimrc" > ~/.vimrc

# Install Plugins. Still need to press <CR>
vim +NeoBundleCheck

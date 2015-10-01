# dotvim
This is my personal vim distribution that is constantly being tweaked over time.
It has many personalized shortcuts that are unique to me, and I wouldn't be able to go back to a text editor without them.

## Installation
Run install.sh or
```bash
git clone https://github.com/jefftree/dotvim.git ~/.vim
cd ~/.vim
git submodule init && git submodule update
echo "so ~/.vim/vimrc" > ~/.vimrc
```

On Linux/Mac, running a direct symlink will be better

`ln -s ~/.vim/vimrc ~/.vimrc`

## Additional Dependencies

- ctags
- Pandoc
- ag (The Silver Searcher)
- Inconsolata-dz Font

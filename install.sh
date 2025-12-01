#!/bin/bash

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
vimrc_backup=/tmp/.vimrc.bak.$timestamp
files="$HOME/.vimrc $HOME/.tigrc"

# backup existing files
for f in $files; do
  if [ -f $f ]; then
    backup_file=/tmp/$(basename $f).$USER.$timestamp
    cp -f $f $backup_file
    echo "Previous $f was backed up to $backup_file"
    echo "You can check the differences with:"
    echo "diff $f $backup_file"
    echo
  else
    echo $f not found. No backup neeeded.
    echo
  fi
done

# get new vimrc
wget -O ~/.vimrc https://raw.githubusercontent.com/ghomem/laziest-vim/refs/heads/main/vimrc &> /dev/null

# setup plugins
mkdir -p ~/.vim/autoload
wget -O ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &> /dev/null

# make sure plugins are installed
echo | vim +PlugInstall +qall &> /dev/null

# fine tune tigrc for colors
egrep color $HOME/.tigrc | grep -v "^#" | grep -q cursor || echo "color cursor default color237" >> $HOME/.tigrc

echo
echo "You vim configuration is now IDEalized."

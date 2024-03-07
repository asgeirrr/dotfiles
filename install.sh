#!/bin/bash
# Development setup script
# * creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# * sets .git_template as the default template folder in Git to enable ctags hooks

########## Variables
dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
# list of files/folders to symlink in homedir
ln_files="vimrc vim fonts gitconfig gitignore git_template ctags isort.cfg pylintrc bashrc zshrc"
cp_files="gnupg/gpg.conf gnupg/scdaemon.conf"
##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# add public keys
mkdir ~/.gnupg
chmod 700 ~/.gnupg

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $ln_files; do
    echo $file
    if [[ -f ~/.$file || -d ~/.$file ]] && [ ! -L ~./$file ]; then
        echo "Moving .$file to $olddir"
        mv ~/.$file ~/dotfiles_old/
    elif [ -L ~./$file ]; then
        unlink .$file
    fi
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
for file in $cp_files; do
    echo "Copying and setting 600 permissions for .$file"
    cp $file ~/.$file
    chmod 600 ~/.$file
done

# Use NeoVim instead of Vim
sudo ln -s /usr/bin/nvim /usr/bin/vim
ln -s ~/.vimrc ~/.config/nvim/init.vim

# Link wezterm to non-standard path
mkdir -p ~/.config/wezterm/
ln -s $dir/wezterm.lua ~/.config/wezterm/wezterm.lua

# Install Vundle for NeoVim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

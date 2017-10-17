#!/bin/bash
# Development setup script
# * creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# * sets .git_template as the default template folder in Git to enable ctags hooks

########## Variables
dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="vimrc vim fonts gitconfig gitignore git_template ctags isort.cfg pylintrc"    # list of files/folders to symlink in homedir
##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
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

#!/bin/bash
if [ $(id -u) != '0' ]; then
    echo "Must be root to run $0"
    exit 1;
fi
MY_USER=$(sh -c 'echo $SUDO_USER')
USER_HOME=$(eval echo ~${SUDO_USER})
packages=('stow' 'zsh' 'lnav' 'htop' 'terminator' 'tmux' 'nethogs')
echo "Uninstall follow packages:"
echo ${packages[@]}
read -p "Are you sure? [y/n] " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    for i in ${packages[@]}; do
        dpkg -s $i &> /dev/null
        if [ $? -eq 0 ]; then
            echo -n "Uninstalling $i... "
            apt-get remove --purge -qq -y  $i &> /dev/null
            echo 'uninstalled'
        else
            echo "Package $i is NOT installed!"
        fi
    done
    echo "Packages removed"
    echo
fi
echo "Remove all downloaded (pluging, fonts, conf, etc)"
read -p "Are you sure? [y/n] " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [ -d "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]
    then
        rm -rf "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    fi
    if [ -d "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]
    then
        rm -rf "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    fi
    if [ -d "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" ]
    then
        rm -rf "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
    fi
    if [ -d "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-256color" ]
    then
        rm -rf "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-256color"
    fi
    if [ -d "$USER_HOME/.oh-my-zsh" ]
    then
        rm -rf "$USER_HOME/.oh-my-zsh"
    fi
    if [ -d "$USER_HOME/fonts" ]
    then
        rm -rf "$USER_HOME/fonts"
    fi
    if [ -d "$USER_HOME/.tmux" ]
    then
        rm -rf $USER_HOME/.tmux
    fi
    rm -rf $USER_HOME/.zshrc
    rm -rf $USER_HOME/.tmux.conf
    rm -rf $USER_HOME/.config/terminator/config
    rm -rf $USER_HOME/tmuxlaunch.sh

    rm -rf ~/.oh-my-zsh
    rm -rf ~/.tmux.conf
    rm -rf ~/tmuxlaunch.sh
    rm -rf ~/.zshrc
    rm -rf ~/.zsh*
    echo "removed"
else
    echo "bye."
    exit 1
fi


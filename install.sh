if [ $(id -u) != "0" ]
then
	echo "Please run this script as root"
	exit 1
fi
#install aplications
apt install -y git zsh stow net-tools
echo -e "\e[1;32mApplications installed\e[0m"
HOME='/home/'$(sh -c 'echo $SUDO_USER')

sed -i 's/enp0s31f6/'$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")'/g' ./tmux/.tmux.conf

#removing old files
rm -rf $HOME/.zshrc
rm -rf $HOME/.tmux.conf
rm -rf $HOME/.config/terminator/config
PWD=echo `pwd`
## install plugings for zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
$(cd $ZSH_CUSTOM/plugins && git clone https://github.com/chrissicool/zsh-256color)

#tmux install plugins
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm


stow zsh -t ~
stow terminator -t ~
stow tmux -t ~

#install fonts
git clone https://github.com/powerline/fonts.git $HOME/fonts
cd $HOME/fonts
./install.sh
source $HOME/.zshrc


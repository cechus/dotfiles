#!/bin/bash
if [ $(id -u) != "0" ]
then
	echo "Please run this script as root"
	exit 1
fi
#install aplications
packages=('stow' 'zsh' 'lnav' 'htop' 'git' 'net-tools' 'terminator' 'tmux' 'nethogs')
echo "Install next packages: "
echo ${packages[@]}
read -p "Are you sure? [y/n] " -n 1
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    for i in ${packages[@]}; do
        dpkg -s $i &> /dev/null
        if [ $? -eq 0 ]; then
            echo "Package $i is Installed!"
        else
            echo -n "Installing $i... "
            apt-get -qq -y install $i &> /dev/null
            echo 'installed'
        fi
    done
	echo -e "\e[1;32mApplications installed\e[0m"


	MY_USER=$(sh -c 'echo $SUDO_USER')
	USER_HOME=$(eval echo ~${SUDO_USER})
	# removing old files
	rm -rf $USER_HOME/.zshrc
	rm -rf $USER_HOME/.tmux.conf
	rm -rf $USER_HOME/.config/terminator/config
	rm -rf $USER_HOME/tmuxlaunch.sh
	# install plugings for zsh
	echo "installing plugings zsh"
	if [ ! -d "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]
	then
		git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	fi

	if [ ! -d "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]
	then
		git clone -q git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	fi
	if [ ! -d "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" ]
	then
		git clone -q https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
		ln -s "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
	fi
	if [ ! -d "${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-256color" ]
	then
		git clone -q https://github.com/chrissicool/zsh-256color ${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-256color
	fi
	echo "installed plugings zsh"

	# tmux install plugins
	echo "installing Tmux Plugin Manager"
	if [ ! -d "$USER_HOME/.tmux/plugins/tpm" ]
	then
		git clone -q https://github.com/tmux-plugins/tpm $USER_HOME/.tmux/plugins/tpm
	fi
	echo "installed Tmux Plugin Manager"
	#set tmux network interface
	sed -i 's/enp0s31f6/'$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")'/g' ./tmux/.tmux.conf
	stow zsh -t $USER_HOME
	stow terminator -t $USER_HOME
	stow tmux -t $USER_HOME

	# install fonts
	if [ ! -d "$USER_HOME/fonts" ]
	then
		git clone -q https://github.com/powerline/fonts.git $USER_HOME/fonts
	fi
	cd $USER_HOME/fonts
	# ./install.sh

	# code of fonts/install.sh
	# Set source and target directories
		powerline_fonts_dir="$( cd "$( dirname "$0" )" && pwd )"

		# if an argument is given it is used to select which fonts to install
		prefix="$1"

		if test "$(uname)" = "Darwin" ; then
		# MacOS
		font_dir="$USER_HOME/Library/Fonts"
		else
		# Linux
		font_dir="$USER_HOME/.local/share/fonts"
		mkdir -p $font_dir
		fi

		# Copy all fonts to user fonts directory
		echo "Copying fonts..."
		find "$powerline_fonts_dir" \( -name "$prefix*.[ot]tf" -or -name "$prefix*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % cp "%" "$font_dir/"

		# Reset font cache on Linux
		if which fc-cache >/dev/null 2>&1 ; then
			echo "Resetting font cache, this may take a moment..."
			# fc-cache -f "$font_dir"
		fi

		echo "Powerline fonts installed to $font_dir"
	# end code of fonts/install.sh

	ln -sf $USER_HOME/.oh-my-zsh ~/.oh-my-zsh
	ln -sf $USER_HOME/.zshrc ~/.zshrc
	chsh -s /bin/zsh root
	chsh -s /bin/zsh $MY_USER
	chown -R $MY_USER:$MY_USER $USER_HOME/.oh-my-zsh
	chown -R $MY_USER:$MY_USER $USER_HOME/.tmux
	chown -R $MY_USER:$MY_USER $USER_HOME/fonts

	# source $USER_HOME/.zshrc
	# source ~/.zshrc
else
    echo "bye."
    exit 1
fi
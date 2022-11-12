#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "[+] Please run as root"
  exit
fi

# colors
blue=$(tput setaf 4)
normal=$(tput sgr0)

mkdir -p /tmp/config

# Install all Kali default tools and upgrade all
echo '[+] Updating && upgrading...'
apt-get -y update &>/dev/null && apt-get -y upgrade &>/dev/null
printf 'Done\n'
printf '[+] Installing Kali Linux default tools... '
apt-get -y install kali-linux-default &>/dev/null
printf 'Done\n'

# Configure pimpmykali.sh
printf '[+] Configuring pimpmykali.sh... '
cd /tmp/config &>/dev/null
wget https://raw.githubusercontent.com/Dewalt-arch/pimpmykali/master/pimpmykali.sh &>/dev/null
chmod +x pimpmykali.sh
sed -i 's/if \[ $distro -ne 1 \]/if [ 1 -e 1 ]/g' pimpmykali.sh &>/dev/null
printf 'Done\n'

# Running pimpmykali.sh:
# 0 - Fix ONLY 1 thru 8
# N - do not enable root login
printf '[+] Running pimpmykali.sh... '
printf '0\nN' | ./pimpmykali.sh &>/dev/null
printf 'Done\n'

# install zsh
printf '[+] Installing zsh... '
apt-get -yqq install zsh &>/dev/null
printf '/bin/zsh' | chsh $USER &>/dev/null
printf 'Done\n'

export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# install oh-my-zsh
printf '[+] Installing oh-my-zsh... '
printf 'Y' | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &>/dev/null
printf 'Done\n'

# install powerlevel10k
printf '[+] Installing powerlevel10k theme... '
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k &>/dev/null
sed -i "s/ZSH_THEME=\".\+\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g" ~/.zshrc &>/dev/null
printf 'Done\n'

# configure powerlevel10k
printf '[+] Configuring powerlevel10k theme... '
zsh -c "printf 'y\ny\ny\ny\n3\n1\n2\n3\n3\n4\n2\n1\n3\n3\n2\n1\n1\ny\n1\ny' | source $ZSH_CUSTOM/themes/powerlevel10k/prompt_powerlevel10k_setup" &>/dev/null
printf 'Done\n'

rm -rf /tmp/config

clear
chown $USER:$USER $HOME/.zshrc
echo 'Run zsh now.'
echo "- Change Kali main theme to Solarized Dark"
echo "- Install FiraCode NF font from:"
echo "  https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"

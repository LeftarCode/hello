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
apt-get -y update && apt-get -y upgrade
printf 'Done\n'
printf '[+] Installing Kali Linux default tools... '
apt-get -y install kali-linux-default
printf 'Done\n'

# Configure pimpmykali.sh
printf '[+] Configuring pimpmykali.sh... '
cd /tmp/config 1> /dev/null
wget https://raw.githubusercontent.com/Dewalt-arch/pimpmykali/master/pimpmykali.sh 1> /dev/null
chmod +x pimpmykali.sh
sed -i 's/if \[ $distro -ne 1 \]/if [ 1 -e 1 ]/g' pimpmykali.sh
printf 'Done\n'

# Running pimpmykali.sh:
# 0 - Fix ONLY 1 thru 8
# N - do not enable root login
printf '[+] Running pimpmykali.sh... '
printf '0\nN' | ./pimpmykali.sh
printf 'Done\n'

# install zsh
printf '[+] Installing zsh... '
apt-get -yqq install zsh
printf '/bin/zsh' | chsh $USER
printf 'Done\n'

export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# install oh-my-zsh
printf '[+] Installing oh-my-zsh... '
printf 'Y' | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
printf 'Done\n'

# install powerlevel10k
printf '[+] Installing powerlevel10k theme... '
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
sed -i "s/ZSH_THEME=\".\+\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g" ~/.zshrc
printf 'Done\n'

# configure powerlevel10k
printf '[+] Configuring powerlevel10k theme... '
zsh -c "printf 'y\ny\ny\ny\n3\n1\n2\n3\n3\n4\n2\n1\n3\n3\n2\n1\n1\ny\n1\ny' | source $ZSH_CUSTOM/themes/powerlevel10k/prompt_powerlevel10k_setup"
printf 'Done\n'

rm -rf /tmp/config

cls 
printf 'Run zsh now.'
#!/bin/bash
echo "This script MUST BE run as root."
echo "Do you want a graphical interface (i3 + lightdm)?"
select graphic in "Yes" "No"; do
  case $graphic in
    Yes )
      graphicInstall=true
      break;;
    No )
      graphicInstall=false
      break;;
    esac
done
echo $graphicInstall
if [ "$graphicInstall" = false ] ; then
  echo "Do you want to install a server? It will install openssh-server, fail2ban, ufw and disable Root login via SSH."
  select server in "Yes" "No"; do
    case $server in
      Yes )
        serverInstall=true
        break;;
      No )
        serverInstall=false
        break;;
      esac
  done
fi

# Base
apt-get update
apt-get upgrade
apt-get install curl git -y

# ZSH + Oh My ZSH avec thème custom
apt-get install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Remove the fucking bell
setterm -blength 0
sed -rin 's/^# set bell-style none/set bell-style none/' /etc/inputrc

# Change the ZSH Theme
curl -o ~/.oh-my-zsh/themes/funkycustom.zsh-theme https://gitlab.matias49.eu/matias49/LinuxInstall/raw/master/funkycustom.zsh-theme
sed -rin 's/robbyrussell/funkycustom/' ~/.zshrc

# Adding the syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -rin 's/plugins=\(git\)/plugins=(git zsh-syntax-highlighting)/' ~/.zshrc

zsh -c 'source ~/.zshrc'

if [ "$graphicInstall" = true ] ; then
  apt-get install i3 lightdm -y
  dpkg-reconfigure lightdm
fi

#!/bin/bash

echo "Do you want a graphical interface (i3 + startx)?"
select graphic in "Yes" "No"; do
  case $graphic in
    Yes )
      graphicInstall = true;
      break;;
    No )
      graphicInstall = false;
      break;;
    esac
done
if[ "$graphicInstall" = false] ; then
  echo "Do you want to install a server? It will install openssh-server, fail2ban, ufw and disable Root login via SSH."
  select server in "Yes" "No"; do
    case $server in
      Yes )
        serverInstall = true
        break;;
      No )
        serverInstall = false
        break;;
      esac
  done
fi
# Base
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install curl git sudo

# ZSH + Oh My ZSH avec thème custom
sudo apt-get install zsh
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

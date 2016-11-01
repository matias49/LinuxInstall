#!/bin/bash
# LAUNCH AS ROOT
# Script d'installation générale de serveur
# Outils installés :
# - curl / wget
# - htop
# - Zsh / Oh My ZSH + custom theme & plugins
# - mail
# - screen
FILE="/tmp/install.txt"
SUBJECT="Notification for `cat /etc/hostname`'s install'"
echo -n "Enter your email for notification : "
read MAIL

echo -n "Enter your custom ZSH theme URL : (press enter to skip) "
read THEMEURL

rm $FILE
touch $FILE

# Remove the fucking bell 
setterm -blength 0
sed -rin 's/^# set bell-style none/set bell-style none/' /etc/inputrc

apt-get update

echo "Upgrade" >>$FILE
apt-get --just-print upgrade 1>>$FILE
apt-get install curl wget htop zsh mailutils git screen ca-certificates screen -y 1>>$FILE

echo "OhMyZSHInstall" >>$FILE
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh >>$FILE
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh

# Change the ZSH Theme
if [ -z "$line" ]; then
    echo "Changing the default theme" >>$FILE
    curl -o ~/.oh-my-zsh/themes/funkycustom.zsh-theme $THEMEURL
    sed -rin 's/robbyrussell/funkycustom/' ~/.zshrc
fi
# Adding the syntax highlighting
echo "Adding Syntax highlighting" >>$FILE
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -rin 's/plugins=\(git\)/plugins=(git zsh-syntax-highlighting)/' ~/.zshrc
zsh -c 'source ~/.zshrc'

chsh -s `which zsh`

mail -s "$SUBJECT" $MAIL < $FILE

exit 0
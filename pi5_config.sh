#!/bin/bash

printf "\nCreating $HOME/Programming and $HOME/Programs directories to install stuff in later...\n"
if [ ! -d $HOME/Programming ]; then
    mkdir $HOME/Programming
fi

if [ ! -d $HOME/Programs ]; then
    mkdir $HOME/Programs
fi

printf "\nDoing a full system update and upgrade...\n"
sudo apt update
sudo apt full-upgrade -y

printf "\nInstalling some utilities and dependencies...\n"
sudo apt install vim git zsh dkms build-essential unzip libelf-dev linux-headers-$(uname -r) -y

printf "\nConfiguring vim...\n"
cd $HOME/Programming
git clone https://github.com/RichTGale/vim-config.git
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp $HOME/Programming/vim-config/.vimrc $HOME/
vim -c PlugInstall

printf "\nConfiguriing zsh...\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
cd $HOME/Programming
git clone https://github.com/richtgale/zsh-config.git
cp $HOME/Programming/zsh-config/.zshrc $HOME/
printf "\nSwitching default shell to zsh...\n"
chsh -s $(which zsh)

printf "\nInstalling TP-Link Archer T2U Plus [RTL8821AU] driver...\n"
cd $HOME/Programs
git clone https://github.com/aircrack-ng/rtl8812au.git
cd rtl8812au
sudo make dkms_install

printf "\nInstalling pigpio\n"
cd $HOME/Programs
wget https://github.com/joan2937/pigpio/archive/master.zip
unzip master.zip
rm -rf master.zip
cd pigpio-master
make
sudo make install

printf "\nYou now have the option to change swapfile space. Press ENTER to continue...\n"
sudo dphys-swapfile swapoff
sudo vim /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

sudo apt autoremove -y
#printf "\nIf you are installing a Pi camera, it might help to load the camera drivers explicitly...\nYou can find more info here: https://www.raspberrypi.com/documentation/computers/camera_software.html#configuration\nNote for Richard: For V2 camera (IMX219), 1) \"change camera_auto_detect=1\" to \"camera_auto_detect=0\", 2) Add \"dtoverlay=imx219\" beneath the \"[all]\" tag. Press ENTER to open the file..."
#sudo vim /boot/firmware/config.txt

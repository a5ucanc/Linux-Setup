#!/bin/bash

#Colors
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


#Check if root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!]${NC} This script must be run as root" 
   exit 1
fi

clear
#Get the user directory
declare -A users=()
count=1
echo "Listing all user folders..."
for file in /home/*/; do
	echo "$count) $file"
	count=($count+1)
	users+="$file"
done
read -p 'Select your user folder: ' index
userdir="${users[$(($index-1))]}"


clear
#Mount windows drive with shared folder
device="/dev/sdc2" #disk name 
monted=0 #flag
echo -e "${BLUE}[*]${NC} Checking mounting device"
if grep -qs '/dev/sdc2 ' /proc/mounts; then #check if already mounted
	read -p $'\e[1;33m[?]\e[0m /dev/sdc2 already mounted. Is this your disk? [y/n] ' yn #check if mounting needed
	if [ $yn == "n" ]; then #get new mounting target
		read -r -p "Enter device name: " device
	else
		mounted=1
	fi
fi

if [ $mounted -eq 0 ]; then #if mounting needed
	echo -e "${BLUE}[*]${NC} Mounting ${device}"
	sudo mkdir /mnt/ntfs_disk
	sudo mount -t ntfs $device /mnt/ntfs_disk
	sudo echo "$device	/mnt/ntfs_disk	ntfs	defaults	0	0" >> /etc/fstab
	sudo ln -s /mnt/ntfs_disk/linux "${userdir}linux"
	echo -e "${GREEN}[+]${NC} Mounted successfully"
fi

echo -e "${BLUE}[*]${NC} Updating the system"
sudo apt-get -qq dist-upgrade -y #upgrade distribution version
sudo apt -qq update -y && sudo apt -qq upgrade -y #update
echo -e "${GREEN}[+]${NC} Updated successfully"

#Download applications
#Check if the apps already installed
declare -A apps=(["google-chrome"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" ["discord"]="https://dl.discordapp.net/apps/linux/0.0.17/discord-0.0.17.deb" ["code"]="https://az764295.vo.msecnd.net/stable/c3511e6c69bb39013c4a4b7b9566ec1ca73fc4d5/code_1.67.2-1652812855_amd64.deb") #dictionary of application command and its download link

echo -e "${BLUE}[*]${NC} Checking installed software"
for item in "${!apps[@]}"
do
	if command -v $item &> /dev/null ; then
		unset apps[$item]
		echo -e "${GREEN}[+]${NC} ${item} already installed"
	fi
done

#Download remaining applications
mkdir "${userdir}Downloads/setup"
cd "${userdir}Downloads/setup"
for item in "${!apps[@]}"
do
	echo -e "${BLUE}[*]${NC} Downloading ${item}"
	sudo wget -q ${apps[$item]}
	echo -e "${BLUE}[**]${NC}  Installing ${item}"
	echo ${apps[$item]} | grep -o '[^\/]*$' | xargs printf -- './%s'|xargs sudo apt install
done
#Clean Downloads directory
cd ..
rm -d -r setup


#Open Burp and Loader
echo -e "${BLUE}[*]${NC} Opening Burpsuite Pro setup"
cd "${userdir}linux/burpsuite_pro"
username=${userdir#/*/}
username=${username%/}
sudo -u $username ./start_kali.sh&
java -jar Loader.jar&



#Create keyboard shortcuts
echo -e "${BLUE}[*]${NC} Creating shortcuts"
echo "[Data_4]
Comment=Comment
Enabled=true
Name=Burp
Type=SIMPLE_ACTION_DATA

[Data_4Actions]
ActionsCount=1

[Data_4Actions0]
CommandURL=${userdir}linux/burpsuite_pro/start_kali.sh
Type=COMMAND_URL

[Data_4Conditions]
Comment=
ConditionsCount=0

[Data_4Triggers]
Comment=Simple_action
TriggersCount=1

[Data_4Triggers0]
Key=Meta+B
Type=SHORTCUT
Uuid={49d7077f-543a-4a80-b053-d7d8b3d52d07}
" >> "${userdir}.config/khotkeysrc"
echo -e "${GREEN}[+]${NC} Burpsuite: Meta+B"

echo "[firefox-esr.desktop]
_k_friendly_name=Firefox ESR
_launch=Meta+F,none,Firefox ESR" >> "${userdir}.config/kglobalshortcutsrc"
echo -e "${GREEN}[+]${NC} Firefox: Meta+F"

echo "[google-chrome.desktop]
_k_friendly_name=Google Chrome
_launch=Meta+C,none,Google Chrome
new-private-window=none,none,New Incognito Window
new-window=none,none,New Window" >> "${userdir}.config/kglobalshortcutsrc"
echo -e "${GREEN}[+]${NC} Chrome: Meta+C"



echo -e "${GREEN}[+] FINISHED${NC}"

##Improvments:
# 	Create applications file with command and download link and load it here make it modular
#	Check stderr on every quiet function
#	Choose between VM installation or Bare metal

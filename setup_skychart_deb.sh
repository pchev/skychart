#!/bin/bash

# work directory
workdir=$(mktemp -d -t)
if [[ -z $workdir ]]; then workdir=/tmp; fi
cd $workdir

#Patrick Chevalley key used to sign the Skychart packages
key=8B8B57C1AA716FC2

aptversion=$(/usr/bin/apt -v)
if [[ $? != 0 ]]; then
  echo "This script is intended to setup the Skychart Debian package with apt."
  echo "It look like this is not the case for your system."
  exit
fi

echo "This script add the Skychart repository to simplify the installation and update of the software."
echo "It is possible to get the STABLE version that is updated every few year,"
echo "or the more frequently updated BETA version with the last features and corrections."
PS3='Please select the version you want: '
options=("Stable" "Beta" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Stable")
            version=stable
            break
            ;;
        "Beta")
            version=unstable
            break
            ;;
        "Quit")
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

echo "You may now give your password for the sudo apt command."
sudo echo OK
if [[ $? != 0 ]]; then exit; fi

#First remove the existing key and repo list if it already exists
sudo apt-key del $key 2>/dev/null
sudo rm /etc/apt/sources.list.d/skychart.list 2>/dev/null

#Create the key with the right format for apt
rm skychart-temp-keyring.gpg $key.key 2>/dev/null
wget --no-verbose -O $key.key "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x$key"
if [[ $? != 0 ]]; then exit; fi
gpg --no-default-keyring --keyring ./skychart-temp-keyring.gpg --import $key.key
gpg --no-default-keyring --keyring ./skychart-temp-keyring.gpg --export --output skychart.gpg
if [[ $? != 0 ]]; then exit; fi
rm skychart-temp-keyring.gpg skychart-temp-keyring.gpg~ $key.key 2>/dev/null

#Install the key and set the new repo list:
sudo mkdir /usr/local/share/keyrings 2>/dev/null
sudo mv skychart.gpg /usr/local/share/keyrings/
sudo sh -c "echo deb [signed-by=/usr/local/share/keyrings/skychart.gpg] http://www.ap-i.net/apt $version main > /etc/apt/sources.list.d/skychart.list"

echo ""
echo "The repository is defined to use the $version packages."
echo "You can now use your prefered package manager to install Skychart."
echo "If you want to continue from the command line do not forget to run: sudo apt update"

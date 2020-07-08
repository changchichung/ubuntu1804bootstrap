##### check apt exists or not 
if pgrep -x apt >/dev/null
then
    echo "apt is running, please wait couple minutes and restart again"
    exit 1
else
    echo "$SERVICE stopped"
    # uncomment to start nginx if stopped
    # systemctl start nginx
    # mail  
fi

##### update apt sources list
echo "##### update apt source list #####"
sudo cp ~/git/ubuntu1804bootstrap/sources.list /etc/apt/sources.list

##### apt update and install apt command

sudo apt install software-properties-common -y


##### disable NetworkManage #####
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
#sudo systemctl disable NetworkManage
#sudo systemctl stop NetworkManage

##### cp timzone #####
echo "##### configure timezone to Asia/Taipei"
sudo cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime

##### stop systemd-resolved #####
echo "##### Stop annoying Systemd-resolved for DNS #####"
sudo systemctl disable systemd-resolved

##### replace the resolv.conf #####
echo "##### add nameservers for this session #####"

sudo tee /etc/resolv.conf << END
nameserver 192.168.11.2
nameserver 192.168.0.10
nameserver 192.168.0.11
nameserver 168.95.1.1
END


##### install resolvconf #####
echo "##### install resolvconf service and add nameservers in /etc/resolvconf/resolv.conf.d/head #####"
sudo apt install resolvconf
sudo tee /etc/resolvconf/resolv.conf.d/head  << END
nameserver 192.168.11.2
nameserver 192.168.0.10
nameserver 192.168.0.11
nameserver 168.95.1.1
END

sudo service resolvconf restart

##### add some repos
echo "##### install some ppa #####"
sudo apt-add-repository ppa:teejee2008/ppa -y
sudo apt-add-repository ppa:libreoffice/ppa -y

##### add apt proxy #####
echo "##### add apt proxy to internal open proxy #####"
sudo tee /etc/apt/apt.conf << END
Acquire::http::proxy "http://192.168.0.2:3128";
END

##### set default option for debconf , no asking question
echo "##### set default debconf options to prevent prompt #####"
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections

##### install packages #####
case "$1" in
    'client')
        echo "##### install packages for desktop #####"
        sudo apt update; sudo apt install -y vim nmon tree nmap curl vim-nox fcitx fcitx-chewing git sshfs wget lynx elinks pigz net-tools postgresql-client golang-go flameshot ssh dconf-editor ncdu xsel
        ##### install google-chrome #####
        echo "##### install google-chrome #####"
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O ~/Downloads/google-chrome.deb
        sudo dpkg -i ~/Downloads/google-chrome.deb
        ##### install Visual Studio code #####
        #echo "install Visual Studio Code"
        #wget https://go.microsoft.com/fwlink/?LinkID=760868 -O ~/Downloads/vs.deb
        #sudo apt -y install gconf2
        #sudo apt --fix-broken install
        #sudo dpkg -i ~/Downloads/vs.deb
        ##### link python to python3.6 #####
        sudo ln -s /usr/bin/python3.6 /usr/bin/python 
        ;;
    'server')
        echo "##### install Server packages #####"
        sudo apt update; sudo apt install -y vim tree nmap curl vim-nox git sshfs wget lynx elinks pigz net-tools nmon ncdu xsel
        ##### link python to python3.6 #####
        sudo ln -s /usr/bin/python3.6 /usr/bin/python
        #####  modify /etc/cloud/cloud.cfg to replace preserve_hostname: False to true #####
        echo "##### update cloud.cfg to preserver hostname #####"
        sudo sed -i -e 's/preserve_hostname\:\ false/preserve_hostname\:\ True/' /etc/cloud/cloud.cfg
        ;;
    '')
        echo "You dont assign the type (Server/Client)!!!"
        ;;
esac

##### install fonts #####
echo "install cascadia fonts"
sudo mkdir -p /usr/share/fonts/truetype/Cascadia
sudo cp ~/git/ubuntu1804bootstrap/Cas*.ttf /usr/share/fonts/truetype/Cascadia/

##### make and export GOPATH #####
echo "##### modify PATH and GOPATH #####"
mkdir $HOME/go
export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"
##### apply .profile #####
tee -a ~/.profile << END
export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"
END

###### clone vimrc and install the plugin #####
#echo "git clone and install vim plugins"
echo "##### git clone vundle , but not enable it #####"
git config --global http.proxy http://192.168.0.2:3128
git config --global https.proxy http://192.168.0.2:3128
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#cp ~/git/ubuntu1804bootstrap/.vimrc ~/
#vim +PluginInstall +qall

##### replace the bashrc #####
echo "##### replace ~/home/.bashrc #####"
cp ~/git/ubuntu1804bootstrap/.bashrc ~/.bashrc
source ~/.bashrc

##### add python3-pip #####
echo "##### install python packages #####"
#sudo apt install -y python3-pip python3-venv python3.6-dev pkg-config graphviz libgraphviz-dev
sudo apt install -y python3-pip python3-venv python3-dev pkg-config graphviz libgraphviz-dev
#sudo pip3 install virtualenv records requests flake8 PyYAML pycp psycopg2 SQLAlchemy django flask pygraphviz
#sudo apt-get install -f exfat-fuse exfat-utils

source $HOME/.bashrc
source $HOME/.profile

#sudo apt-get -o Dpkg::Options::='--force-confold' --force-yes -fuy upgrade
#export DEBIAN_FRONTEND=noninteractive
#yes '' | sudo apt -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" upgrade

##### install debconf
echo "##### install debconf-tuils #####"
sudo apt install debconf-utils -y
##### import debconf 
echo "##### import debconf #####"
sudo debconf-set-selections < ~/git/ubuntu1804bootstrap/selections.conf

#call post_install.sh to decide run system upgrade and snapshot or not
sudo bash post_install.sh


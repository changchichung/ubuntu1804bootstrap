##### mkdir git folder #####
mkdir $HOME/git
cd $HOME/git
##### cp timzone #####
echo "copy Asia/Taipei timezone"
sudo cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime


##### stop systemd-resolved #####
echo "Stop annoying Systemd-resolved for DNS "
sudo systemctl disable systemd-resolved

##### replace the resolv.conf #####
echo "add nameservers for this session"
echo -e "nameserver 192.168.0.10\nnameserver 192.168.0.11\nnameserver 8.8.8.8\nnameserver 8.8.4.4"|sudo tee --append /etc/resolv.conf > /dev/null


##### install resolvconf #####
echo "install resolvconf service and add nameservers is /etc/resolvconf/resolv.conf.d/base "
sudo apt install resolvconf
echo -e "nameserver 192.168.0.10\nnameserver 192.168.0.11\nnameserver 8.8.8.8\nnameserver 8.8.4.4"|sudo tee --append /etc/resolvconf/resolv.conf.d/base > /dev/null

sudo service resolvconf restart

##### install packages #####
case "$1" in
    'client')
        echo "install packages for desktop"
        sudo apt update; sudo apt install -y vim tree nmap curl vim-gtk fcitx fcitx-chewing git sshfs wget lynx elinks pigz tilix net-tools postgresql-client golang-go flameshot ssh
        ##### install google-chrome #####
        echo "install google-chrome"
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
        echo "install Server packages"
        sudo apt update; sudo apt install -y vim tree nmap curl vim-gtk git sshfs wget lynx elinks pigz net-tools postgresql-client golang-go
        ##### link python to python3.6 #####
        sudo ln -s /usr/bin/python3.6 /usr/bin/python
        #####  modify /etc/cloud/cloud.cfg to replace preserve_hostname: False to true #####
        sudo sed -i -e 's/preserve_hostname\:\ false/preserve_hostname\:\ True/' /etc/cloud/cloud.cfg
        ;;
    '')
        echo "You dont assign the type (Server/Client)!!!"
        ;;
esac


##### make and export GOPATH #####
echo "modify PATH and GOPATH"
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
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#
#mkdir $HOME/git
##git clone http://219.85.234.104:3000/changch/ubuntu1804bootstrap ~/git/ubuntu1804bootstrap
#cp ~/git/ubuntu1804bootstrap/.vimrc ~/
#vim +PluginInstall +qall

##### replace the bashrc #####
echo "replace ~/home/.bashrc"
cp ~/git/ubuntu1804bootstrap/.bashrc ~/.bashrc
source ~/.bashrc

##### add python3-pip #####
echo "install python3 packages and pip3 packages"
sudo apt install -y python3-pip python3-venv python3.6-dev pkg-config graphviz libgraphviz-dev
sudo pip3 install virtualenv records requests flake8 PyYAML pycp psycopg2 SQLAlchemy django flask pygraphviz
sudo apt-get install -f exfat-fuse exfat-utils

#source $HOME/.bashrc
#source $HOME/.profile


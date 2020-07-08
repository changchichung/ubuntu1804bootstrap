##### Bootstrap for Ubuntu 18.04 #####

1. ~~stop damn NetworkManage~~

由於關閉 NetworkManage 會導致筆電上的無線網路無法正常透過DHCP取得IP
所以先拿掉取消 NetworkManage 的部份

```
systemctl disable NetworkManage
```

2. stop systemd-resolved
```
ubuntu 18.04 預設採用systemd-resolved ，但是這個會導致修改/etc/resolv.conf只有在當次開機階段有效。
重新開機之後，就會被覆蓋成預設的 127.0.0.53。
要關閉systemd-resolved 服務，改用resolvconf來協助進行設定。
```

3. install resolvconf to help config DNS
```
也許可以不這樣做，在關閉NetworkManage & systemd-resolved 之後
應該是可以直接建立 /etc/resolv.conf，不會再被覆蓋
```

4. 安裝套件

**vim-nox for enable lua support in VIM , to use neocomplete**

#### Server
```
vim tree nmap curl vim-gtk git sshfs wget lynx elinks pigz net-tools
```
#### Client
```
vim tree nmap curl vim-gtk fcitx fcitx-chewing git sshfs wget lynx elinks pigz tilix net-tools postgresql-client golang-go flameshot ssh
```

5. (optional)手動執行以下指令，安裝vundle for vim
vundle 安裝方式
```
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```
然後輸入以下指令進行安裝 vim plugin (注意大小寫)

```
:PluginInstall +qall
```
就可以安裝以下的vim 套件 
```
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'VundleVim/Vundle.vim'
Plugin 'zxqfl/tabnine-vim'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'scrooloose/nerdtree'
"Plugin 'pearofducks/ansible-vim'
"Plugin 'chase/vim-ansible-yaml'
Plugin 'KabbAmine/yowish.vim'
Plugin 'altercation/vim-colors-solarized'
```

F3 用來呼叫/關閉 NERDTree
ctrl+b 預覽Markdown 文件

6.匯入調整好的 .bashrc，加入自訂function rb作為隨手備份檔案、資料夾用。

7.安裝google-chrome **only for client**

8.~~安裝 MS Visual Studio Code 出乎意料的好用！~~

9.執行時，指令後面帶 server/client 會安裝不一樣的套件，已修正當未加入server/client時，會跳警告訊息

10. vim 新增 F4 快捷鍵，插入time stamp 
``` 2020-03-17 09:35:45```


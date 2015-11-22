#!bin/bash

# TODO:

pkgmgr = $1;

# BASICS
$pkgmgr -y update
$pkgmgr -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
$pkgmgr -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
git config --global color.ui true

# NODE.JS
git clone https://github.com/creationix/nvm.git ~/.nvm
cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
cd ~/
echo "source ~/.nvm/nvm.sh" >> ~/.profile
source ~/.profile
nvm install 0.10
nvm use 0.10
nvm alias default 0.10

# RUBY ON RAILS
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.2 --rails
source ~/.rvm/scripts/rvm
rvm use 2.2.2 --default
gem install bundler

$pkgmgr -y update

# GO
wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz
tar -C /usr/local -xvf go*.tar.gz

# MYSQL
$pkgmgr -y dist-upgrade
$pkgmgr -y install mysql-client
$pkgmgr -y install mysql-server

# POSTGRES
$pkgmgr -y postgresql-server

# REDIS
wget -P /opt/ http://download.redis.io/releases/redis-3.0.2.tar.gz
tar xzf /opt/redis-3.0.2.tar.gz
cd /opt/redis-3.0.2
make
ln -s /opt/redis-3.0.2/src/redis-server /usr/local/bin/redis-server
# TODO: add redis to auto start on startup

$pkgmgr -y update

# MONGODB
# TODO: Get mongodb

$pkgmgr -y update

# NGINX
apt-get -y install nginx-full

# GIT COMPLETION
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
mkdir ~/scripts
mv git-completion.bash ~/scripts/git-completion.bash

# VIM SETUP
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp .vimrc ~/.vimrc
vim +PluginInstall +qall

# POWERLINE SETUP
pip install --user powerline-status
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# BASH_PROFILE SETUP
cat .bash_profile >> ~/.bash_profile
source ~/.bash_profile

# SET CAPS LOCK TO CTRL
setxkbmap -layout us -option ctrl:nocaps


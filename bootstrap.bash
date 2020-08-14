#!/bin/bash -ex

# VERSIONS
go_ver="1.15"
node_ver="12.18.3"

os=`uname -s`

pkgmgr() {
  sudo dnf -y "$@"
}

distro="fedora"
wm=""

if [[ $os == "Darwin" ]]; then
  pkgmgr() {
    brew "$@"
  }
  distro="mac"
  wm="mac"
elif [[ $os == "Linux" ]]; then
  wm=`echo $XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]'`
  apt=`grep -ioh -e ubuntu -e debian /etc/*release`
  if [[ "$apt" ]]; then
    echo "Using apt-get"
    pkgmgr() {
      sudo apt-get -y "$@"
    }
    distro="$apt"
  else
    echo "Using dnf"
  fi
fi

dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# BASICS
pkgmgr update
pkgmgr install -y git curl zlib1g-dev build-essential libssl-dev libreadline-dev \
  libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties \
  libffi-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev ruby-full

# GIT SETUP
git config --global color.ui true
mv git-templates ~/.git-templates
chmod a+x ~/.git-templates/hooks/*

# VIM SETUP
pkgmgr install -y vim
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp ${dotfiles_dir}/.basicvimrc ~/.vimrc
vim +PluginInstall +qall
cp ~/.vim/bundle/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/

# NODE.JS
curl -O https://nodejs.org/dist/v${node_ver}/node-v${node_ver}-linux-x64.tar.xz
tar -xvf node*.tar.xz -C /usr/local

# RUBY ON RAILS
gem install rails
gem install bundler

pkgmgr update

# GO
curl -O https://storage.googleapis.com/golang/go${go_ver}.linux-amd64.tar.gz
tar -C /usr/local -xvf go*.tar.gz
echo -e "\n# GO" | tee -a ~/.bash_profile
echo "export GOPATH=$HOME/go" | tee -a ~/.bash_profile
echo "export GOBIN=$GOPATH/bin" | tee -a ~/.bash_profile
echo "export PATH=$PATH:$GOPATH/bin" | tee -a ~/.bash_profile

# ERLANG & ELIXIR
pkgmgr install -y erlang
pkgmgr install -y elixir

# LISP
pkgmgr install -y clisp

# MYSQL
pkgmgr install -y mysql-client
pkgmgr install -y mysql-server mysql-community-server

# POSTGRES
pkgmgr install -y postgresql-server
echo -e "\n# POSTGRES\nexport PGDATA=/usr/local/var/postgres" >> ~/.bash_profile

# REDIS
wget -P /opt/ http://download.redis.io/releases/redis-stable.tar.gz
tar xzf /opt/redis-stable.tar.gz
cd /opt/redis-stable
make
ln -s /opt/redis-stable/src/redis-server /usr/local/bin/redis-server
# TODO: add redis to auto start on startup

# MONGODB
pkgmgr install -y mongodb mongodb-server

# NGINX
pkgmgr install -y nginx-full

# SET CAPS LOCK TO CTRL
setxkbmap -layout us -option ctrl:nocaps

# SETUP FOR VSCODE
if [[ "$vscode" -eq 1 ]]; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  dnf install code
fi

# TEXMAKER
pkgmgr install -y texmaker

# MONITORING
pip install s-tui --user
pkgmgr install -y htop stress

echo "PATH=$PATH:/.local/bin" >> .bash_profile

## TODO:
# 1. Install presto, zsh, and pure theme
# 2. Install anaconda for python
# 3. Install kafka, zookeeper, and prometheus
# 4. Install spark and hadoop
# 5. Install java and scala

# DISTRO SPECIFIC
if [[ ${dotfiles_dir}/${wm}_packages.txt ]]; then
  for pkg in `cat ${dofiles_dir}/${distro}_packages.txt`; do
    pkgmgr install $pkg;
  done
fi

# CLEANUP
rm ${dotfiles_dir}/go*
rm -rf ${dotfiles_dir}/git
pkgmgr update



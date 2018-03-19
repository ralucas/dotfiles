#!/bin/bash -ex

powerline=0
vscode=0

while getopts ":pvh" opt; do
  case ${opt} in
    p ) powerline=1
      ;;
    v ) vscode=1
      ;;
    h ) echo -e "\tUsage: \n\tsh bootstrap.sh [-p for powerline install] [-v for vscode install]"; exit 0
      ;;
  esac
done

os=`uname -s`

pkgmgr() {
  sudo dnf -y "$@"
}

distro="fedora"

if [ "${os}" == "Darwin" ]; then
  pkgmgr() {
    brew "$@"
  }
  distro="mac"
elif [ "$os" == "Linux" ]; then
  apt=`grep -iE 'ubuntu|debian' /etc/*release`
  if [[ "$apt" -n ]]; then
    echo "Using apt-get"
    pkgmgr() {
      sudo apt-get -y "$@"
    }
  else
    echo "Using dnf"
  fi
fi

dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# BASICS
pkgmgr update
pkgmgr install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
pkgmgr install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
git config --global color.ui true

# BASH_PROFILE SETUP
cat ${dotfiles_dir}/.bash_profile >> ~/.bash_profile
source ~/.bash_profile

# VIM SETUP
pkgmgr install vim
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp ${dotfiles_dir}/.vimrc ~/.vimrc
vim +PluginInstall +qall
cp ~/.vim/bundle/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/

# NODE.JS
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
source ~/.bash_profile
nvm install node
nvm use node

# RUBY ON RAILS
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby --rails
source ~/.rvm/scripts/rvm
rvm use 2.2.2 --default
gem install bundler

pkgmgr update

# GO
wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz
tar -C /usr/local -xvf go*.tar.gz
echo -e "\n# GO" | tee -a ~/.bash_profile
echo "export GOPATH=$HOME/go" | tee -a ~/.bash_profile
echo "export GOBIN=$GOPATH/bin" | tee -a ~/.bash_profile
echo "export PATH=$PATH:$GOPATH/bin" | tee -a ~/.bash_profile

# PYTHON
pkgmgr install numpy opencv*
sudo pip install numpy
sudo pip install matplotlib
sudo pip install scipy

# ERLANG & ELIXIR
pkgmgr install erlang
pkgmgr install elixir

# LISP
pkgmgr install clisp

# MYSQL
pkgmgr dist-upgrade
pkgmgr install mysql-client
pkgmgr install mysql-server

# POSTGRES
pkgmgr postgresql-server
echo -e "\n# POSTGRES\nexport PGDATA=/usr/local/var/postgres" >> ~/.bash_profile

# REDIS
wget -P /opt/ http://download.redis.io/releases/redis-stable.tar.gz
tar xzf /opt/redis-stable.tar.gz
cd /opt/redis-stable
make
ln -s /opt/redis-stable/src/redis-server /usr/local/bin/redis-server
# TODO: add redis to auto start on startup

# MONGODB
pkgmgr install mongodb mongodb-server

# NGINX
pkgmgr install nginx-full

# GIT COMPLETION
echo -e "\n# GIT COMPLETION & PROMPT" | tee -a ~/.bash_profile
echo -e "source /usr/share/git-core/contrib/completion/git-completion.bash" | tee -a ~/.bash_profile
echo -e "source /usr/share/git-core/contrib/completion/git-prompt.sh" | tee -a ~/.bash_profile
source ~/.bash_profile

# POWERLINE SETUP
pip install --user powerline-status
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

echo -e "\n# COMMAND LINE PROMPT" >> ~/.bash_profile
if [[ "$powerline" -eq 1 ]]; then
  echo -e "\nsource $HOME/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh" >> ~/.bash_profile
  source ~/.bash_profile
else
  echo "PS1='[\e[36m\u@\h \e[34m\W\e[31m$(__git_ps1 " (%s)")\e[0m] \$ '" | tee -a ~/.bash_profile
fi

# SET CAPS LOCK TO CTRL
setxkbmap -layout us -option ctrl:nocaps

# SETUP FOR VSCODE
if [[ "$vscode" -eq 1 ]]; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  dnf install code
fi

# DISTRO SPECIFIC
if [[ ${dotfiles_dir}/${distro}_packages.txt -n ]]; then
  for pkg in `cat ${dofiles_dir}/${distro}_packages.txt`; do
    pkgmgr install $pkg;
  done
fi

# CLEANUP
rm ${dotfiles_dir}/go*
pkgmgr update


#!/bin/bash -ex

# VERSIONS
go_ver="1.17.2"

os=$(uname -s | tr "[:upper:]" "[:lower:]")
os_arch="64"

if [[ "$(uname -m)" != *"64"* ]]; then
  os_arch="32"
fi

pkgmgr() {
  sudo dnf -y "$@"
}

distro="fedora"
window_mgr=""

if [[ $os == "darwin" ]]; then
  pkgmgr() {
    brew "$@"
  }
  distro="mac"
  window_mgr="mac"
elif [[ $os == "linux" ]]; then
  window_mgr=$(echo "$XDG_CURRENT_DESKTOP" | tr "[:upper:]" "[:lower:]")
  apt=$(grep -ioh -e ubuntu -e debian /etc/*release)
  if [[ "$apt" ]]; then
    echo "Using apt"
    pkgmgr() {
      sudo apt -y "$@"
    }
  distro=$(echo "$apt" | head -1 | tr "[:upper:]" "[:lower:]")
  else
    echo "Using dnf"
  fi
fi

dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Running script"
echo "---------------"
echo "OS: $os"
echo "Distro: $distro"
echo "Windows Manager: $window_mgr"
echo "Architecture: $os_arch-bit"
echo "---------------"

# BASICS
if [[ $distro != "mac" ]]; then
  echo "Updating and installing packages"
  pkgmgr update
  pkgmgr install git curl zsh build-essential automake shellcheck python3 python3-pip
fi

# GIT SETUP
echo "setting up git..."
cp .gitconfig "$HOME"/.gitconfig
cp .gitignore_global "$HOME"/.gitignore_global
cp -R git-templates "$HOME"/.git-templates
chmod a+x "$HOME"/.git-templates/hooks/*

## VIM SETUP
echo "installing vim..."
pkgmgr install vim
mkdir -p "$HOME"/.vim/bundle
mkdir -p "$HOME"/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim.git "$HOME"/.vim/bundle/Vundle.vim
cp "${dotfiles_dir}/.basicvimrc_starter" "$HOME"/.vimrc
vim +PluginInstall +qall
cp "$HOME"/.vim/bundle/vim-colors-solarized/colors/solarized.vim "$HOME"/.vim/colors/
cat "${dotfiles_dir}/.basicvimrc_starter" "${dotfiles_dir}/.basicvimrc_end" > .vimrc
mv .vimrc "$HOME"/.vimrc

# INSTALL prezto
echo "installing prezto..."
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" || \
  (cd "${ZDOTDIR:-$HOME}"/.zprezto && git restore . && git pull --recurse-submodules && cd "${dotfiles_dir}") 
mv "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zshrc "${ZDOTDIR:-$HOME}"/.zshrc
for rcfile in $(ls "${ZDOTDIR:-$HOME}"/.zprezto/runcoms); do
  if [[ "$rcfile" != "README*" ]]; then
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}" || true
  fi
done

# INSTALL pure theme
echo "installing pure theme..."
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure" || \
  (cd "$HOME/.zsh/pure" && git pull && cd "${dotfiles_dir}") 
cat <<EOT >> "$HOME/.zshrc"
## Pure Prompt
fpath+=\$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure
EOT

# Update zsh history config
echo "" >> "$HOME/.zshrc"
cat <<EOT >> "$HOME/.zshrc"
################################################################################################
## History Configuration
################################################################################################
HISTSIZE=1000000
HISTFILE=\$HOME/.zsh_history
SAVEHIST=1000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.]

EOT

# GO
echo "installing go..."
go_arch="amd64"
if [[ "$os_arch" == "32" ]]; then
  go_arch="386"
fi
curl -O "https://storage.googleapis.com/golang/go${go_ver}.${os}-${go_arch}.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xvf go*.tar.gz
mkdir -p "$HOME"/.go
GOPATH="$HOME"/.go
echo "" >> "$HOME/.zshrc"
cat <<EOT >> "$HOME/.zshrc"
## GO
export PATH=\$PATH:/usr/local/go/bin
export GOPATH=$GOPATH
export GOBIN=\$GOPATH/bin
export PATH=\$PATH:\$GOPATH/bin
EOT
sudo rm "${dotfiles_dir}"/go*

# MONITORING
echo "installing monitoring tools..."
pip3 install s-tui --user
pkgmgr install htop stress
echo "PATH=\$PATH:/.local/bin" >> "$HOME"/.zshrc

# DISTRO SPECIFIC
echo "installing distro specific packages..."
echo "${dotfiles_dir}/${window_mgr}_packages.txt"
if [[ -f "${dotfiles_dir}/${window_mgr}_packages.txt" ]]; then
  echo "installing packages..."
  pkgs=($(cat "${dotfiles_dir}/${window_mgr}_packages.txt" | tr "\n" " "))
  for pkg in ${pkgs[@]}; do
    echo "installing $pkg"
    pkgmgr install "$pkg"
  done
fi

chsh -s /bin/zsh
zsh
source "$HOME"/.zshrc


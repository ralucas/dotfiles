txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/richardlucas/.rvm/bin
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/richardlucas/.rvm/bin
export PGDATA=/usr/local/var/postgres

##
# Your previous /Users/richardlucas/.bash_profile file was backed up as /Users/richardlucas/.bash_profile.macports-saved_2013-09-16_at_18:30:34
##

# MacPorts Installer addition on 2013-09-16_at_18:30:34: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# __loopback-oracle-installer__:  Tue Jan  7 08:56:35 MST 2014
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/Users/richardlucas/sls-sample-app/node_modules/loopback-connector-oracle/node_modules/instantclient"

# Android SDK
export PATH=${PATH}:/Users/richardlucas/Development/adt-bundle/sdk/platform-tools:/Users/richardlucas/Development/adt-bundle/sdk/tools

# ANT
ANT_HOME=/Users/richardlucas/Development/apache-ant-1.9.3
export PATH=${PATH}:${ANT_HOME}/bin

# JAVA
JAVA_HOME=/usr/libexec/java_home
export PATH=${PATH}:${JAVA_HOME}

print_before_the_prompt () {
    printf "\n$txtred%s: $bldgrn%s $txtcyn%s\n$txtrst" "$USER" "$PWD" "$(vcprompt)"
    }

    PROMPT_COMMAND=print_before_the_prompt

PS1='-> $ '

# tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
# tell grep to highlight matches
export GREP_OPTIONS='--color=auto'
# alias
alias ls='ls -FGal'

if [ -d "$HOME/Library/Python/2.7/bin" ]; then
        PATH="$HOME/Library/Python/2.7/bin:$PATH"
fi

source ~/git-completion.bash
source /Users/richardlucas/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh


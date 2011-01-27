# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

umask 022

# the rest of this file is commented out.

# include .bashrc if it exists

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# do the same with MANPATH
if [ -d ~/man ]; then
    MANPATH=~/man:"${MANPATH}"
fi

if [ -f /usr/games/fortune ]; then
	/usr/games/fortune -a
fi

#if [ -f ~/.keymap ]; then
#	loadkeys ~/.keymap
#fi

export HISTFILESIZE=10000
#unset HISTFILE

export HISTSIZE=10000
export HISTCONTROL=ignoredups

/usr/bin/keychain --nogui --timeout 1440 ~/.ssh/id_rsa
[[ -f $HOME/.keychain/$HOSTNAME-sh ]] && source $HOME/.keychain/$HOSTNAME-sh
#/usr/bin/keychain --nogui --timeout 60 --agents gpg
#[[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && source ~/.keychain/$HOSTNAME-sh-gpg

source ~/.bash/functions.sh

export PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/bin:/sbin:$PATH

export CVS_RSH="ssh"

# less sweetness
eval $(lesspipe)

export MPD_PORT=6600
export MPD_HOST=enchufe.local

export PGDATABASE=scorepress
export PGUSER=scorepress
export LESS=-q
export PAGER="less -R"

# If running interactively, then:
if [ "$PS1" ]; then
	# don't put duplicate lines in the history. See bash(1) for more options
	# export HISTCONTROL=ignoredups

	# enable color support of ls and also add handy aliases
	eval `dircolors -b`
	# enable bash completion in interactive shells
	if [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi

	if [ -f $HOME/.aliases ]; then
		. $HOME/.aliases
	fi

	# set a fancy prompt
	PS1='\u@\h:\W\$ '

	# If this is an xterm set the title to user@host:dir
	case $TERM in
		xterm*)
			#do_xterm
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
		;;
		*)
		;;
	esac

fi

# python virtualenvs
export WORKON_HOME=~/code/python/envs
source /usr/local/bin/virtualenvwrapper.sh

# ~/.bashrc

# This file is sourced for *interactive* shells on startup, including
# some apparently interactive shells such as scp which can't tolerate
# any output.  So make sure there is no output or bad things will
# happen!

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Shell Options

# Use vi command-line editing
set -o vi

# Do not overwrite files without checking with the user.  If you need to
# overwrite, use >| instead of just >.
set -o noclobber

# Bash won't catch SIGWINCH if other process is in the foreground.  By
# enabling this option, bash checks the terminal size upon regaining
# control.
shopt -s checkwinsize

# Enable history appending instead of overwriting
shopt -s histappend

# Keep pollution down on history by removing all 'ls' and others, and
# ignoring lines that begin with a space.
HISTCONTROL=ignoreboth:erasedups

# Set history sizes to a more reasonable number
HISTSIZE=10000; HISTFILESIZE=100000;
HISTIGNORE='cd:history*:ls:less:man*:vi'

# Set a history timestamp format so that when we have multiple shells,
# we don't forget the history of the ones that were closed first.
HISTTIMEFORMAT='%d/%m/%y %H:%M '

# Preferred applications and options

export EDITOR=vim

export LESS="$LESS -R -F -X"
type -P lesspipe >/dev/null && export LESSOPEN=${LESSOPEN:-|lesspipe %s}

# Enable Tab- completion in Python when invoked interactively.
export PYTHONSTARTUP=$HOME/.pythonrc

# Change window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
		PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
		;;
esac

# Decide if this terminal is capable of color output and set a colorful prompt
use_color=false
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
		PS2='\[\033[32m\]> \[\033[37m\]'
	fi

	# If present, enable user additions to colors in the ls command.
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi
else
	# Set a simple prompt for terminals with no color
	PS1='\h \W \$ '
fi

# Load machine-specific configuration files
[ -z $SHORTHOST ] && SHORTHOST=$(hostname -s)
[ -f $HOME/.bashrc-$SHORTHOST ] && source $HOME/.bashrc-$SHORTHOST

# Load generic and machine specific alias files
[ -f $HOME/.alias ] && source $HOME/.alias
[ -f $HOME/.alias-$SHORTHOST ] && source $HOME/.alias-$SHORTHOST

# Load keychain
[ -f $HOME/.keychain/$HOSTNAME-sh     ] && source $HOME/.keychain/$HOSTNAME-sh
[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && source $HOME/.keychain/$HOSTNAME-sh-gpg

# Add ~/bin and current directory to PATH
export PATH=$PATH:~/bin:.

unset use_color safe_term match_lhs

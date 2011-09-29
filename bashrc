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
HISTSIZE=100; HISTFILESIZE=5000
HISTIGNORE="cd:history:ls"

# Set a history timestamp format so that when we have multiple shells,
# we don't forget the history of the ones that were closed first.
HISTTIMEFORMAT='%d/%m/%y %H:%M '

# Preferred applications
export EDITOR=vim
type -P lesspipe >/dev/null && export LESSOPEN=${LESSOPEN:-|lesspipe %s}

# Add ~/bin and current directory to PATH
export PATH=$PATH:~/bin:.

# Enable Tab- completion in Python when invoked interactively.
export PYTHONSTARTUP=$HOME/.pythonrc

# Change the title of X terminals
case ${TERM} in
        xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
                PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
                ;;
        screen)
                PROMPT_COMMAND='echo -ne "\033_${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
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

# Load bash completion modules
if [[ -f /etc/gentoo-release ]] ; then
	bash_completion='/etc/profile.d/bash-completion.sh'
else
	bash_completion='/etc/bash_completion'	
fi

[ -f $bash_completion ] && source $bash_completion

# Load aliases and machine-specific configuration files
[ -f $HOME/.aliases ] && source $HOME/.aliases
[ -f $HOME/.bashrc-$HOSTNAME ] && source $HOME/.bashrc-$HOSTNAME

unset bash_completion use_color safe_term match_lhs

# vim: tw=72 ts=4 sts=4 sw=4:

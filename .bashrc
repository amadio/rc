# ~/.bashrc

[[ $- == *i* ]] || return

for sh in /etc/{,bash/}bashrc ~/.bashrc.d/* ; do
       [[ -r ${sh} ]] && source "${sh}"
done

export PATH="${PATH}:${HOME}/bin:."


PATH=.:~/bin:$PATH
alias dockerclean='docker rm $(docker ps -a -q -f status=exited); docker rmi $(docker images -f "dangling=true" -q)'

export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;36m\]\$(__git_ps1 '(%s)')\[\033[01;0m\]\n$ "
export EDITOR="/usr/bin/nano"

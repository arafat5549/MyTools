alias gitpush='sh gitpush.sh '
alias xpl="sh xpl.sh "

alias df='df -h'
alias du='du -h'

alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour

alias ls='ls -h --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #
alias wch='which -a'
alias lld='ls --color=tty -l|grep --color=auto ^d'
alias llf='ls --color=tty -l|grep --color=auto ^-'
alias llda='ls -al|grep --color ^d'
alias llfa='ls -al|grep --color  ^-'

alias cdjava='cd "F:\workspace_javaee"'
alias cdphp='cd "F:\dev\Php\workspace"'
alias cdhome='cd "F:\cygwin64\home"'
alias cdjs2='cd "F:\dev\JS"'
alias cdssf='cd "F:\workspace_javaee\MyShop"'
alias cdshop='cd "F:\workspace_javaee\ShopDemo"'
alias cdssm='cd "F:\workspace_javaee\MySSMShop"'
alias cddown='cd "F:\编程工具类"'
alias cdredis2='cd "F:\vagrant-redis"'
alias cdredis='cd "F:\Program Files\redis-latest"'

alias startredis='sh xpl.sh redis-server.exe redis.windows.conf'

alias open='cmd /c start '
alias subl='cmd /c sl.lnk '
alias tnpm='npm --registry=https://registry.npm.taobao.org \
--disturl=https://npm.taobao.org/dist'

alias docki='docker images'
alias dockiuntag='docker images -q -f "dangling=true"'
alias dockp='docker ps'
alias dockpa='docker ps -a'

alias dockkilla='docker kill $(docker ps -a -q)'
alias dockstopa='docker stop $(docker ps -a -q)'
alias dockrma='docker rm $(docker ps -a -q)'
alias dockrmia='docker rmi $(docker images -q -f dangling=true)'
alias dockclean='dockercleanc || true && dockercleani'

alias docknginx='docker run -d --name myNginx -p 8080:80 -v `~/env/www/html`:/usr/share/nginx/html nginx'
alias dockstartnginx='docker start $(docker ps -a -q -f "name=myNginx")'
alias dockstopnginx='docker stop $(docker ps -q -f "name=myNginx")'
alias dockclearnginx='dockstopnginx && docker rm $(docker ps -a -q -f "name=myNginx")'

alias dockredis='docker run --name myRedis -p 6379:6379 -d redis'
alias dockstartredis='docker start $(docker ps -a -q -f "name=myRedis")'
alias dockstopredis='docker stop $(docker ps -q -f "name=myRedis")'

alias dockmysql='docker run --name myMysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql'
alias dockstartmysql='docker start $(docker ps -a -q -f "name=myMysql")'
alias dockstopmysql='docker stop $(docker ps -q -f "name=myMysql")'

alias dockpostgres='docker run --name myPostgres -p 5432:5432 -e POSTGRES_PASSWORD=123456  -d postgres'
alias dockstartpostgres='docker start $(docker ps -a -q -f "name=myPostgres")'
alias dockstoppostgres='docker stop $(docker ps -q -f "name=myPostgres")'

alias dockphpfpm='docker run --name myFpm -p 9000:9000 -v `~/env/www/html`:/usr/share/nginx/html -d bitnami/php-fpm'
alias dockstartphpfpm='docker start $(docker ps -a -q -f "name=myFpm")'
alias dockstopphpfpm='docker stop $(docker ps -q -f "name=myFpm")'
alias dockclearphpfpm='dockstopphpfpm && docker rm $(docker ps -a -q -f "name=myFpm")'

alias dockwyya='docknginx && dockredis && dockmysql && dockpostgres'
alias dockstarta='dockstartnginx && dockstartredis && dockstartmysql && dockstartpostgres'
#alias dockwyystop='docknginx && dockredis && dockmysql && dockpostgres'

#netstat -ano | findstr "0.0.0.0:80"
#test
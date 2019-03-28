daemonize false
environment 'production'
bind "unix:///var/www/top52/socket"

threads 4,20
#workers 1

stdout_redirect "/var/www/top52/shared/log/web_stdout.log", "/var/www/top52/shared/log/web_stderr.log", true

#daemonize true
#environment 'production'
#bind "unix:///var/www/top52/socket"
#directory "/var/www/top52"

#threads 4,20
#workers 1

#stdout_redirect "/var/www/top52/shared/log/web_stdout.log", "/var/www/top52/shared/log/web_stderr.log", true
#pidfile "/var/www/top52/shared/puma.pid"
#state_path "/var/www/top52/shared/puma.state"

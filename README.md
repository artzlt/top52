## Установка и запуск

1. `git clone`
2. `sudo apt-get install php7.2`
2. `sudo apt-get install inkscape`
2. `sudo apt-get install ghostscript`
2. `sudo apt-get install openjdk-8-jdk` (найти текущую версию OpenJDK из `sudo apt-cache search openjdk`)
3. `sudo apt-get install postgresql-9.6` (найти текущую версию Postgres из `sudo apt-cache search postgresql`)
4. Поставить rbenv, установить jruby-9.1.10.0
5. Установить bundler в папке с проектом: `gem install bundler`
6. `bundle install`.
7. `sudo -u postgres psql`<br />
postgres=# `create user dbuser_dev;`<br />
postgres=# `\password dbuser_dev`  # Password: `pass`<br />
postgres=# `alter user dbuser_dev CREATEDB;`
8. `rake db:setup`
9. Аналогично создать пользователя БД postgres для production
10. Установить плагин rbenv-vars для rbenv
11. В папке с проектом создать и заполнить файл .rbenv-vars:<br />
SECRET_KEY_BASE={секретный ключ, который можно сгенерировать командой rake secret}<br />
APP_DB_USER={пользователь БД, созданный для production на шаге 9}<br />
APP_DB_PASSWORD={пароль пользователя БД, созданного для production, заданный на шаге 9}<br />
12. `rake db:setup RAILS_ENV=production`
13. `rake assets:precompile`
14. Для запуска приложения после настройки, выполнить: `bundle exec puma`
<br /><br />Для разворачивания сервиса наружу:
15. Установить Nginx (`sudo apt-get install nginx`)
16. Использовать конфиг Nginx из ./shared/top52 (поместить его в /etc/nginx/sites-available и в /etc/nginx/sites-enabled)
17. Перезапустить nginx (`sudo service nginx restart`)

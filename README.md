## Установка и запуск

1. `git clone`
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
9. Аналогично создать юзера для production
10. Установить плагин rbenv-vars для rbenv
11. В папке с проектом создать и заполнить файл .rbenv-vars:<br />
SECRET_KEY_BASE={секретный ключ, который можно сгенерировать командой rake secret}<br />
APP_DB_USER={юзер, созданный для production на шаге 9}<br />
APP_DB_PASSWORD={пароль юзера, созданного для production, заданный на шаге 9}<br />
12. `rake db:setup RAILS_ENV=production`
13. `rake assets:precompile`
14. Для запуска приложения после настройки, выполнить: `bundle exec puma`

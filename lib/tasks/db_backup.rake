namespace :db do
  task :backup => :environment do
    time = Time.current
    tar = "./shared/db_backups/#{time.strftime('%d%m%Y_%H%M')}.tar"
    system "mkdir -p ./shared/db_backups"
    system "PGPASSWORD=#{ENV['APP_DB_PASSWORD']} pg_dump -U #{ENV['APP_DB_USER']} -h localhost -f #{tar} -F tar new_octoshell"
    system "gzip #{tar}"
  end
end

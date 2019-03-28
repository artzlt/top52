namespace :db do
  task :restore_from_tar, [:path] do |t, args|
    tar = args.path
    system "echo", "PGPASSWORD=#{ENV['APP_DB_PASSWORD']} pg_restore -c -U #{ENV['APP_DB_USER']} -h localhost -F tar -d new_octoshell #{tar}"
  end
end

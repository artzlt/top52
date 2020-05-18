require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: rake db:restore_from_tar[BACKUP_PATH] -t TABLE_NAME"
  opts.on("-t", "--table ARG", String) { |table| options[:table] = table }
end.parse!

namespace :db do
  task :restore_from_tar, [:path, ] do |t, args|
    tar = args.path
    table = ""
    if options.include? :table
      table = "-t " + options[:table]
    end
    system "PGPASSWORD=#{ENV['APP_DB_PASSWORD']} pg_restore -c -U #{ENV['APP_DB_USER']} -h localhost -F tar -d new_octoshell #{tar} #{table}"
    exit
  end
end

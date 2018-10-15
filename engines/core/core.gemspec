$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "core"
  s.version     = Core::VERSION
  s.authors     = ["N1"]
  s.email       = ["n1@mail.ru"]
  s.homepage    = "http://www.real.com"
  s.summary     = "summ."
  s.description = "desc."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.1.4"

  s.add_dependency "activerecord-jdbcpostgresql-adapter"
  s.add_dependency "decorators", "~> 1.0.2"
  s.add_dependency "state_machine"
  s.add_dependency "slim"
  s.add_dependency "sidekiq"
  s.add_dependency "sidekiq-failures"
  s.add_dependency "sshkey"
  s.add_dependency "net-ssh"
  s.add_dependency "net-scp"
  s.add_dependency "maymay"
  s.add_dependency "ransack"
  s.add_dependency "kaminari"
  s.add_dependency "clbustos-rtf"
  s.add_dependency "mini_magick"
  s.add_dependency "carrierwave"

  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency "rspec-rails"
end

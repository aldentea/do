require 'rspec/core/rake_task'

# create database for test.
user = ENV['DO_MYSQL_USER'] || 'root'
pass = ENV['DO_MYSQL_PASS'] || ''
command = %Q(mysql -u #{user} #{pass.empty? ? '' : "-p#{pass}"} -e "create database if not exists do_test;")
`#{command}`

RSpec::Core::RakeTask.new(:spec => [:clean, :compile]) do |spec|
  spec.pattern      = './spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov => [:clean, :compile]) do |rcov|
  rcov.pattern    = "./spec/**/*_spec.rb"
  rcov.rcov       = true
  rcov.rcov_opts  = File.read('spec/rcov.opts').split(/\s+/)
end

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "xtify"
  gem.homepage = "http://github.com/moxiespaces/xtify"
  gem.license = "MIT"
  gem.summary = %Q{Client library for Xtify's API}
  gem.description = gem.summary
  gem.email = "jbell@moxiesoft.com"
  gem.authors = ['Jonathan Bell']
  # Do not add dependencies here because Jewler will add them from the Gemfile
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

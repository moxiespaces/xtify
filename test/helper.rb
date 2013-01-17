require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'webmock/test_unit'
require 'shoulda-context'


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'xtify'

Xtify.configure do |config|
  config.app_key = 'FAKE_APP_KEY'
  config.api_key = 'FAKE_API_KEY'
  config.verbose = false
end

class Test::Unit::TestCase
  def stub_xtify_post(url, data)
    stub_http_request(:post, File.join(Xtify::Commands::API_V2, url)).
      with(:body => data)
  end
end
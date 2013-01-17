require 'curl'
require 'active_support/all'

module Xtify
  autoload :Config, 'xtify/config'
  autoload :Model, 'xtify/model'
  autoload :Device, 'xtify/device'
  autoload :Action, 'xtify/action'
  autoload :Message, 'xtify/message'
  autoload :Commands, 'xtify/commands'

  def self.config
    @config
  end
  
  def self.configure(&block)
    @config = Config.new
    yield @config
  end

  extend Commands
end

require 'xtify/errors'
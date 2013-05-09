module Xtify
  class Config
    attr_accessor :api_key, :verbose, :app_key_ios, :app_key_gcm

    def self.setup(config_file = nil, environment = nil)
      config = nil
      if defined? Rails
        config_file ||= File.join(Rails.root, 'config', 'xtify.yml')
        environment ||= Rails.env
        config = YAML.load(File.read(config_file))
      end
      c = self.new
      c.api_key = config[environment]['api_key'] if config
      c.app_key_ios = config[environment]['app_key_ios'] if config
      c.app_key_gcm = config[environment]['app_key_gcm'] if config
      c
    end

  end
end
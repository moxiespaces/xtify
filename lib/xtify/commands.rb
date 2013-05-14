module Xtify
  module Commands

    API_V2 = "http://api.xtify.com/2.0"

    # Register and return a device with the provided details which 
    # can be used to refer to this device in the Xtify system. 
    # Calling this endpoint with a device that is already 
    # registered will result in the existing device being returned.
    #
    # Parameters:
    # - install_id      -> (Required) This id along with your application key will 
    #                      uniquely identify your user in our system 
    #                      and is used to manage uninstalls/reinstalls 
    #                      and mapping registrations to existing users. 
    #                      It does not have to be the device’s IMEI or 
    #                      true device identifier. This must be unique 
    #                      for every user of your application.
    #
    #                      Please note: If you use a custom install ID and 
    #                      call the registration service from the same device 
    #                      (ie same device token) multiple times with the same 
    #                      install ID, the user will receive multiple messages.
    #
    # - type            -> (Required) The SDK device type you have implemented in your app.
    #
    #                      Values restricted to: Xtify::Device::TYPES
    #
    # - device_token    -> The Apple provided deviceToken received by registering
    #                      with APNS
    #
    # - registration_id -> The Google provided registrationId received by 
    #                      registering with google’s cloud to device service.
    #
    # - blackberry_pin  -> The RIM provided device PIN received by registering 
    #                      with the BlackBerry Push service.
    #
    # - user_key        -> An optional customer defined key which can be 
    #                      associated with this user. Available to premium/enterprise 
    #                      customers.
    #
    # - install_date    -> Install date of this user.
    #
    # - badge           -> Current badge for iOS only
    #
    # - v_os            -> The operating system version of the device.
    #
    # - model           -> The model name/number of the device.
    #
    # - carrier         -> The carrier in use by the device.
    #
    # - Returns a Xtify ID for device
    def register_device(opts={})
      validate_arguments('register_device', opts, :install_id, :type)
      validate_in_set('register_device', :type, opts, Device::TYPES.values)
    
      args = convert_to_args(opts,
        :blackberry_pin => 'blackberryPIN',
        :v_os => 'vOS'
      )

      result = post('users/register', args)
      Device.new(result)
    end

    # The Xtify Push API allows you to immediately send a message to a set of users that 
    # you can select by Device, positive or negative tags, or a "send to all" flag. By 
    # exposing our push interface via API, you can generate timely one-off notifications 
    # and event-based messages from within your own service either by hand or automatically.
    #
    # - devices       -> A device or array of devices to send message to
    # - has_tags      -> All devices with these tags will receive message
    # - not_tags      -> All devices without these tags will receive message
    # - send_all      -> All users of the application will recieve message
    # - index_only    -> Index only indicator for rich message
    # - content       -> Message or Hash of message
    def push(opts={})
      xids = Array.wrap(opts.delete(:devices)).map {|d| d.is_a?(Device) ? d.xid : d}
      device_type = opts.delete(:device_type)
      has_tags = Array.wrap(opts.delete(:has_tags))
      not_tags = Array.wrap(opts.delete(:not_tags))
      content = opts.delete(:content)
      unless content.is_a?(Message)
        content = Message.new(content)
      end

      args = convert_to_args(opts)
      args[:apiKey] = config.api_key
      args[:content] = content
      args[:xids] = xids unless xids.empty?
      args[:hasTags] = has_tags unless has_tags.empty?
      args[:notTags] = not_tags unless not_tags.empty?
      
      args['type'] = device_type

      post('push', args)
    end

    protected

    def convert_to_args(opts, mappings={})
      args = {}
      opts.each do |key, value|
        mapped_to = mappings[key]
        if mapped_to
          args[mapped_to] = value
        else
          camelized = key.to_s.camelcase(:lower).gsub(/Id/, 'ID')
          args[camelized] = value
        end
      end
      args
    end

    def validate_arguments(command, args, *keys)
      missing = []

      keys.each do |key|
        missing << key unless args[key]
      end

      raise InvalidRequest.new("Must specify #{missing.join(",")} when requesting #{command}.") unless missing.empty?
      true
    end

    def validate_in_set(command, key, opts, set)
      unless set.include?(opts[key])
        raise InvalidRequest.new("#{key} must be one of: #{set.join(", ")} when requesting #{command}")
      end
    end

    def post(command, opts)
      args = opts.dup
      raise ConfigError.new("Must specify app_key in Xtify initializer.") unless (config.app_key_ios || config.app_key_gcm)
      args[:appKey] = config.send("app_key_#{args['type'].downcase}")
      args.delete('type') if command == 'push'

      response = Curl::Easy.perform(File.join(API_V2, command)) do |curl|
        curl.verbose = config.verbose
        curl.headers['Content-Type'] = 'application/json'
        curl.post_body = args.to_json
      end

      if response.response_code == 200
        JSON.parse(response.body_str)
      elsif response.response_code == 202
        true
      else
        raise CommandFailure.new("Error performing: #{command}: #{response.body_str}")
      end
    end
  end
end
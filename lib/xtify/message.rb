module Xtify
  class Message
    include Model

    xtify_model :subject, :message, :payload, :sound, :badge

    one :action
    one :rich, :type => Message

    # See Xtify.push
    def push(opts={})
      Xtify.push(opts.merge(:content => self))
    end
  end
end
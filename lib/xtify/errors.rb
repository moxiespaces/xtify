module Xtify
  class Error < StandardError
  end

  class ConfigError < Error
  end

  class InvalidRequest < Error
  end

  class CommandFailure < Error
  end
end
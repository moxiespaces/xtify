module Xtify
  class Action
    include Model

    xtify_model :type, :data, :label

    TYPES = {
      :url => "URL",
      :rich => "RICH",
      :custom => "CUSTOM",
      :phone => "PHONE",
      :default => "DEFAULT",
      :none => "NONE"
    }

    RICH_TYPES = {
      :web => "WEB",
      :phone => "PHN",
      :custom => "CST",
      :default => "DEFAULT",
      :none => "NONE"
    }
  end
end
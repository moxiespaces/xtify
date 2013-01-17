module Xtify
  class Device
    include Model

    xtify_model :xid

    TYPES = {
      :apple => "IOS",
      :blackberry => "BLACKBERRY",
      :android => "GCM"
    }
  end
end
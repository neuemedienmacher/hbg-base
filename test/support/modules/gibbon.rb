module Gibbon
  class API
    def self.lists
      Gibbon::ClaratListStub.new
    end
  end

  class ClaratListStub
    def subscribe attrs
      true
    end
  end
end

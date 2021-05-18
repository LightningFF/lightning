module Lightning
  module Flaggable
    def ff_display
      "#{self.name} (#{self.class.to_s})"
    end
  end
end

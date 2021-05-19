module Lightning
  module Flaggable
    def lightning_display
      "#{self.id} - #{self.name} (#{self.class.to_s})"
    end
  end
end

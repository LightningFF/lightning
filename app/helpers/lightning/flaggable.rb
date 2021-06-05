module Lightning
  module Flaggable
    def lightning_display
      if self.respond_to?(:name)
        "#{self.id} - #{self.name}"
      else
        self.id
      end
    end
  end
end

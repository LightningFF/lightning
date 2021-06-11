module Lightning
  module Flaggable
    def lightning_display
      if self.respond_to?(:name)
        "#{self.id} - #{self.name}"
      else
        self.id
      end
    end

    # List of 3-element hashes containing a unique id, method, and display name
    # (i.e [{id: 1, method: :free, display_name: "Free Tier"}])
    def lightning_criterions
      []
    end
  end
end

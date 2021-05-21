require "lightning/version"
require "lightning/engine"
require "lightning/api"

module Lightning
  # Your code goes here...
  mattr_accessor :flaggable_entities

  def self.flaggable_entities
    @@flaggable_entities.map { |f| f.constantize }
  end
end

require "lightning/version"
require "lightning/engine"

module Lightning
  # Your code goes here...
  mattr_accessor :entity_class

  def self.entity_class
    @@entity_class.constantize
  end
end

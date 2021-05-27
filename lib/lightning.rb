require 'lightning/version'
require 'lightning/engine'
require 'lightning/api'
require 'lightning/errors'

module Lightning
  # Your code goes here...
  mattr_accessor :flaggable_entities

  def self.flaggable_entities
    @@flaggable_entities.map { |f| f.constantize }
  end

  class << self
    delegate :create!, :get, :list, :update, :delete, :entities, :enable_entity, :remove_entity, :enabled?, to: Api
  end
end

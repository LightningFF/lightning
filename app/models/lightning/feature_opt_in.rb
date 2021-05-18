module Lightning
  class FeatureOptIn < ApplicationRecord
    belongs_to :feature

    attr_accessor :entity_id
    belongs_to :entity, class_name: Lightning.entity_class.to_s

    before_validation :set_entity

    private
    def set_entity
      self.entity = Lightning.entity_class.find(entity_id)
    end

  end
end

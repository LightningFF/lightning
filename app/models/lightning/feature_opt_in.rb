module Lightning
  class FeatureOptIn < ApplicationRecord
    belongs_to :feature

    attr_accessor :entity_id

    belongs_to :entity, polymorphic: true
    before_validation :set_entity

    def entity_name
      if entity.respond_to?(:lightning_display)
        entity.lightning_display
      else
        entity.id
      end
    end

    private

    def set_entity
      self.entity = self.entity_type.constantize.find_by_id(self.entity_id)
    end

  end
end

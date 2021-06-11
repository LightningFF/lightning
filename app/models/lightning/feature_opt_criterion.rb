module Lightning
  class FeatureOptCriterion < ApplicationRecord
    belongs_to :feature

    validates :entity_type, presence: true
    validates :entity_method, presence: true
  end
end

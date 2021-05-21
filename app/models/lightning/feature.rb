module Lightning
  class Feature < ApplicationRecord

    enum state: { disabled: 0, enabled_globally: 1, enabled_per_entity: 2 }, _default: :disabled
    has_many :feature_opt_ins

  end
end

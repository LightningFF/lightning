class User < ApplicationRecord
  include Lightning::Flaggable

  # has_many :feature_opt_ins, as: :entity

  def lightning_criterions
    [{ id: 1, method: :is_free, display_name: "Free Tier" }, { id: 2, method: :is_paid, display_name: "Pro Tier" }]
  end

  def is_paid
    false
  end

  def is_free
    true
  end
end

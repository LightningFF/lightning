module Lightning
  class Feature < ApplicationRecord

    enum state: { inactive: 0, enabled_globally: 1, enabled_per_entity: 2 }, _default: :enabled_per_entity
    has_many :feature_opt_ins

    def self.enabled_for?(account, feature_key)
      joined_table = Feature.left_outer_joins(:feature_opt_ins)
      joined_table.where(key: feature_key, state: :enabled_per_entity, feature_opt_ins: {entity_id: account.id, entity_type: account.class.to_s}).or(joined_table.where(key: feature_key, state: :enabled_globally)).exists?
    end


    def self.create(key, description, state)
      feature = Feature.new
      feature.key = key
      feature.description = description
      feature.state = state
      feature.save!
    end

    def self.delete(key)
      Feature.find_by_key(key)&.destroy
    end

    def set_description(desc)
      self.update({description: desc})
    end

    def add_account(account)
      permissioned_account = self.feature_opt_ins.new
      permissioned_account.entity_id = account.id
      permissioned_account.entity_type = account.class.to_s
      permissioned_account.save!
    end

    def accounts
      self.feature_opt_ins.all.map{|f| f.entity}
    end

    def enabled_for?(account)
      self.enabled_globally? or self.feature_opt_ins.where(entity_id: account.id, entity_type: account.class.to_s)
    end

    def remove(account)
      self.feature_opt_ins.find(entity_id: account.id, entity_type: account.class.to_s)&.destroy
    end

  end
end

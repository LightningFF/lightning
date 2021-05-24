module Lightning
  class Api
    class FeatureError < StandardError
    end

    def self.create!(key, description = '')
      Feature.create!(key: key, description: description)
    rescue StandardError
      raise FeatureError, 'Failed to create new feature'
    end

    def self.get(key)
      Feature.find_by_key!(key)
    rescue StandardError
      raise ::Lightning::Errors::FeatureNotFound, "Feature with key: #{key} not found"
    end

    def self.list
      Feature.all
    end

    def self.update(key, attributes)
      get(key).update(attributes)
    end

    def self.delete(key)
      get(key).destroy
    end

    def self.entities(key)
      get(key).feature_opt_ins.all.map(&:entity)
    end

    def self.enable_entity(key, entity)
      permissioned_entity = get(key).feature_opt_ins.new
      permissioned_entity.entity_id = entity.id
      permissioned_entity.entity_type = entity.class.to_s
      permissioned_entity.save!
    end

    def self.remove_entity(key, entity)
      get(key).feature_opt_ins.find(entity_id: entity.id, entity_type: entity.class.to_s)&.destroy
    end

    def self.enabled?(entity, feature_key)
      joined_table = Feature.left_outer_joins(:feature_opt_ins)
      joined_table.where(key: feature_key, state: :enabled_per_entity,
                         feature_opt_ins: { entity_id: entity.id, entity_type: entity.class.to_s }).or(joined_table.where(key: feature_key,
                                                                                                                          state: :enabled_globally)).exists?
    end
  end
end

# frozen_string_literal: true

module Lightning
  class Api

    def self.create!(key, description = '')
      Feature.create!(key: key, description: description)
    rescue StandardError
      raise ::Lightning::Errors::FailedToCreate, 'Failed to create new feature'
    end

    def self.get(key)
      Feature.find_by!(key: key)
    rescue StandardError
      raise ::Lightning::Errors::FeatureNotFound, "Feature with key: #{key} not found"
    end

    def self.list
      Feature.all
    end

    def self.update(key, attributes)
      get(key).update(attributes)
    rescue ArgumentError
      raise ::Lightning::Errors::InvalidFeatureState, "Failed to update state. State must be one of the following: #{Feature.states.keys} "
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
      get(key).feature_opt_ins.find_by(entity_id: entity.id, entity_type: entity.class.to_s)&.destroy
    rescue ActiveRecord::RecordNotFound
      raise ::Lightning::Errors::EntityNotFound, "Could not find entity with id #{entity.id} and type #{entity.class.to_s}"
    end

    def self.enabled?(entity, feature_key)
      joined_table = Feature.left_outer_joins(:feature_opt_ins)
      joined_table
        .where(key: feature_key, state: :enabled_per_entity, feature_opt_ins: { entity_id: entity.id, entity_type: entity.class.to_s })
        .or(joined_table.where(key: feature_key, state: :enabled_globally))
        .exists?
    end
  end
end
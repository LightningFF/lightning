# frozen_string_literal: true

module Lightning
  module Api
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

    def self.opt_ins(key)
      get(key).feature_opt_ins.all.map(&:entity)
    end

    def self.opt_in(key, entity)
      get(key).feature_opt_ins.find_or_create_by!(entity_id: entity.id, entity_type: entity.class.to_s)
    end

    def self.opt_out(key, entity)
      get(key).feature_opt_ins.find_by(entity_id: entity.id, entity_type: entity.class.to_s)&.destroy
    rescue ActiveRecord::RecordNotFound
      raise ::Lightning::Errors::EntityNotFound, "Could not find entity with id #{entity.id} and type #{entity.class.to_s}"
    end

    def self.enabled?(feature_key, entity)
      enabled_entity = Feature.where(key: feature_key).left_outer_joins(:feature_opt_ins).where("state = ? OR (state = ? AND lightning_feature_opt_ins.entity_id = ? AND lightning_feature_opt_ins.entity_type = ?)", Feature.states[:enabled_globally], Feature.states[:enabled_per_entity], entity.id, entity.class.to_s).exists?
      # Check if the entity has any valid criteria
      unless enabled_entity
        entity_id_to_method_map = entity.class.new.lightning_criterions.map{|c| [c[:id], c[:method]]}.to_h
        criterions = Feature.where(key: feature_key).left_outer_joins(:feature_opt_criterions).where("state = ? AND lightning_feature_opt_criterions.entity_type = ?", Feature.states[:enabled_per_entity], entity.class.to_s).select("lightning_feature_opt_criterions.entity_method")
        criterions.each do |criterion|
          method = entity_id_to_method_map[criterion.entity_method.to_i]
          if entity.respond_to?(method) && entity.public_send(method)
            return true
          end
        end
      end
      return enabled_entity
    end
  end
end

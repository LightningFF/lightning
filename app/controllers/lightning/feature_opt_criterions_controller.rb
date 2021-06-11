require_dependency "lightning/application_controller"

module Lightning
  class FeatureOptCriterionsController < ApplicationController

    def create
      @feature = Feature.find(params[:feature_id])
      criterion = JSON.parse(params[:feature_opt_criterion][:criterion_type])
      entity_type = criterion[0]
      entity_method = criterion[1]

      @feature.feature_opt_criterions.find_or_create_by!(entity_type: entity_type, entity_method: entity_method)
      flash[:notice] = "Permissions has been created!"
      redirect_to @feature
    rescue => e
      flash[:notice] = "Failed to opt in some entities: #{e.message}"
      redirect_to @feature
    end

    def destroy
      @feature = Feature.find(params[:feature_id])
      @feature_opt_criterion = @feature.feature_opt_criterions.find(params[:id])
      @feature_opt_criterion.destroy
      redirect_to @feature, notice: 'Feature permission was successfully destroyed.'
    end
  end
end

require_dependency "lightning/application_controller"

module Lightning
  class FeatureOptInsController < ApplicationController

    def create
      @feature = Feature.find(params[:feature_id])
      entity_ids = params[:feature_opt_in][:entity_id].split(",")
      entity_class = params[:feature_opt_in][:entity_type].constantize

      entity_ids.each do |entity_id|
        entity = entity_class.find(entity_id)
        @feature.feature_opt_ins.find_or_create_by!(entity_id: entity.id, entity_type: entity_class.to_s)
      end

      flash[:notice] = "Permissions has been created!"
      redirect_to @feature
    rescue => e
      flash[:notice] = "Failed to opt in some entities: #{e.message}"
      redirect_to @feature
    end

    def destroy
      @feature = Feature.find(params[:feature_id])
      @feature_opt_in = @feature.feature_opt_ins.find(params[:id])
      @feature_opt_in.destroy
      redirect_to @feature, notice: 'Feature permission was successfully destroyed.'
    end

    private

    def feature_opt_ins_params
      params.require(:feature_opt_in).permit(:entity_id, :entity_type)
    end

  end
end

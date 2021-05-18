require_dependency "lightning/application_controller"

module Lightning
  class FeatureOptInsController < ApplicationController

    def create
      entity_id, entity_type = JSON.parse(params[:feature_opt_in][:entity])
      @feature = Feature.find(params[:feature_id])
      @feature_opt_in = @feature.feature_opt_ins.new
      @feature_opt_in.entity_id = entity_id
      @feature_opt_in.entity_type = entity_type
      @feature_opt_in.save!
      flash[:notice] = "Permissions has been created!"
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
      params.require(:feature_opt_in).permit(:entity)
    end

  end
end

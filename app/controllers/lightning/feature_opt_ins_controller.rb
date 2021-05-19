require_dependency "lightning/application_controller"

module Lightning
  class FeatureOptInsController < ApplicationController

    def create
      @feature = Feature.find(params[:feature_id])
      @feature_opt_in = @feature.feature_opt_ins.new
      @feature_opt_in.entity_id = params[:feature_opt_in][:entity_id]
      @feature_opt_in.entity_type = params[:feature_opt_in][:entity_type]
      if @feature_opt_in.save
        flash[:notice] = "Permissions has been created!"
      else
        flash[:notice] = "FAILED TO SAVE PERMISSIONS! INVALID ENTITY ID!"
      end
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

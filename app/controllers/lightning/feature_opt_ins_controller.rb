require_dependency "lightning/application_controller"

module Lightning
  class FeatureOptInsController < ApplicationController

    def create
      @feature = Feature.find(params[:feature_id])
      @feature_opt_ins = @feature.feature_opt_ins.create(feature_opt_ins_params)
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
      defaults = { entity_type: Lightning.entity_class.to_s }
      params.require(:feature_opt_in).permit(:entity_id, :entity_type).reverse_merge(defaults)
    end

  end
end

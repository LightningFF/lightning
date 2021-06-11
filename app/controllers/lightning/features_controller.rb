require_dependency "lightning/application_controller"

module Lightning
  class FeaturesController < ApplicationController
    before_action :set_feature, only: [:show, :edit, :update, :destroy]

    def index
      @features = Feature.all
    end

    def show
      @flaggable_entities = Lightning.flaggable_entities

      @criterion_select_options = []
      @criterion_method_id_name_map = {}
      @flaggable_entities.each do |entity|
        entity_str = entity.to_s
        @criterion_method_id_name_map[entity_str] = {}
        entity.new.lightning_criterions.each do |criterion|
          display_name = criterion[:display_name]
          criterion_id = criterion[:id]
          @criterion_select_options << ["#{entity_str} - #{display_name}", [entity_str, criterion_id]]
          @criterion_method_id_name_map[entity_str][criterion_id] = display_name
        end
      end
    end

    def new
      @feature = Feature.new
    end

    def edit
    end

    def create
      @feature = Feature.new(feature_params)

      if @feature.save
        redirect_to @feature, notice: 'Feature was successfully created.'
      else
        render :new
      end
    end

    def update
      if @feature.update(feature_params)
        redirect_to @feature, notice: 'Feature was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @feature.destroy
      redirect_to features_url, notice: 'Feature was successfully destroyed.'
    end

    private

    def set_feature
      @feature = Feature.find(params[:id])
    end

    def feature_params
      params.require(:feature).permit(:key, :description, :state)
    end
  end
end

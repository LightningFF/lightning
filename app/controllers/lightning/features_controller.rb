require_dependency "lightning/application_controller"

module Lightning
  class FeaturesController < ApplicationController
    before_action :set_feature, only: [:show, :edit, :update, :destroy]

    # GET /features
    def index
      @features = Feature.all
    end
    #
    # GET /features/1
    def show
      @flaggable_entities = Lightning.flaggable_entities
    end

    # GET /features/new
    def new
      @feature = Feature.new
    end

    # GET /feature/1/edit
    def edit
    end

    # POST /features
    def create
      @feature = Feature.new(feature_params)

      if @feature.save
        redirect_to @feature, notice: 'Feature was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /features/1
    def update
      if @feature.update(feature_params)
        redirect_to @feature, notice: 'Feature was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /features/1
    def destroy
      @feature.destroy
      redirect_to features_url, notice: 'Feature was successfully destroyed.'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def feature_params
      params.require(:feature).permit(:key, :description, :state)
    end
  end
end

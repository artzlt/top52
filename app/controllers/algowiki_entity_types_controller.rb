class AlgowikiEntityTypesController < ApplicationController
  before_action :set_algowiki_entity_type, only: [:show, :edit, :update, :destroy]

  # GET /algowiki_entity_types
  def index
    @algowiki_entity_types = AlgowikiEntityType.all
  end

  # GET /algowiki_entity_types/1
  def show
  end

  # GET /algowiki_entity_types/new
  def new
    @algowiki_entity_type = AlgowikiEntityType.new
  end

  # GET /algowiki_entity_types/1/edit
  def edit
  end

  # POST /algowiki_entity_types
  def create
    @algowiki_entity_type = AlgowikiEntityType.new(algowiki_entity_type_params)

    if @algowiki_entity_type.save
      redirect_to :algowiki_entity_types, notice: 'Algowiki entity type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /algowiki_entity_types/1
  def update
    if @algowiki_entity_type.update(algowiki_entity_type_params)
      redirect_to @algowiki_entity_type, notice: 'Algowiki entity type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /algowiki_entity_types/1
  def destroy
    @algowiki_entity_type.destroy
    redirect_to algowiki_entity_types_url, notice: 'Algowiki entity type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_algowiki_entity_type
      @algowiki_entity_type = AlgowikiEntityType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def algowiki_entity_type_params
      params.require(:algowiki_entity_type).permit(:name, :name_eng, :parent_id)
    end
end

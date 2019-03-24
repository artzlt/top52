class AlgowikiRelationTypesController < ApplicationController
  before_action :set_algowiki_relation_type, only: [:show, :edit, :update, :destroy]

  # GET /algowiki_relation_types
  def index
    @algowiki_relation_types = AlgowikiRelationType.all
  end

  # GET /algowiki_relation_types/1
  def show
  end

  # GET /algowiki_relation_types/new
  def new
    @algowiki_relation_type = AlgowikiRelationType.new
  end

  # GET /algowiki_relation_types/1/edit
  def edit
  end

  # POST /algowiki_relation_types
  def create
    @algowiki_relation_type = AlgowikiRelationType.new(algowiki_relation_type_params)

    if @algowiki_relation_type.save
      redirect_to :algowiki_relation_types, notice: 'Algowiki relation type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /algowiki_relation_types/1
  def update
    if @algowiki_relation_type.update(algowiki_relation_type_params)
      redirect_to :algowiki_relation_types, notice: 'Algowiki relation type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /algowiki_relation_types/1
  def destroy
    @algowiki_relation_type.destroy
    redirect_to algowiki_relation_types_url, notice: 'Algowiki relation type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_algowiki_relation_type
      @algowiki_relation_type = AlgowikiRelationType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def algowiki_relation_type_params
      params.require(:algowiki_relation_type).permit(:name, :name_eng)
    end
end

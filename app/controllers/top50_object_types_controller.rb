class Top50ObjectTypesController < ApplicationController

  def index
    @top50_object_types = Top50ObjectType.all
  end

  def show
    @top50_object_type = Top50ObjectType.find(params[:id])
  end
 
  def new
    @top50_object_type = Top50ObjectType.new
  end

  def create
    @top50_object_type = Top50ObjectType.new(top50object_type_params)
    @top50_object_type[:is_valid] = 0
    @top50_object_type[:comment] = "Added type"
    if @top50_object_type.save
      redirect_to :top50_object_types
    else
      render :new
    end
  end

  def edit
    @top50_object_type = Top50ObjectType.find(params[:id])
  end

  def update
    @top50_object_type = Top50ObjectType.find(params[:id])
    @top50_object_type.update_attributes(top50object_type_params)
    redirect_to :top50_object_types
  end

  def destroy
    @top50_object_type = Top50ObjectType.find(params[:id])
    @top50_object_type.destroy
    redirect_to :top50_object_types
  end



  def default
    Top50ObjectType.default!
  end

  private

  def top50object_type_params
    params.require(:top50_object_type).permit(:name, :name_eng, :parent_id)
  end
end

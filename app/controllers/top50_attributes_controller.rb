class Top50AttributesController < ApplicationController

  def index
    @top50_attributes = Top50Attribute.all
  end

  def show
    @top50_attribute = Top50Attribute.find(params[:id])
  end
 
  def new
    @top50_attribute = Top50Attribute.new
  end

  def create
    @top50_attribute = Top50Attribute.new(top50attribute_params)
    @top50_attribute[:is_valid] = 0
    @top50_attribute[:comment] = "Added attribute"
    if @top50_attribute.save
      redirect_to :top50_attributes
    else
      render :new
    end
  end

  def edit
    @top50_attribute = Top50Attribute.find(params[:id])
  end

  def update
    @top50_attribute = Top50Attribute.find(params[:id])
    @top50_attribute.update_attributes(top50attribute_params)
    redirect_to :top50_attributes
  end

  def destroy
    @top50_attribute = Top50Attribute.find(params[:id])
    @top50_attribute.destroy
    redirect_to :top50_attributes
  end



  def default
    Top50Attribute.default!
  end

  private

  def top50attribute_params
    params.require(:top50_attribute).permit(:name, :name_eng, :attr_type)
  end
end

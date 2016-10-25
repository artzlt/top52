class Top50AttributeDbvalsController < ApplicationController

  def index
    @top50_attributes_dbval = Top50AttributeDbval.includes(:top50_attribute).all
  end

  def show
    @top50_attribute = Top50Attribute.find(params[:id])
    @top50_attribute_dbval = Top50AttributeDbval.find(params[:id])
  end
 
  def new
    @top50_attribute = Top50Attribute.new
    @top50_attribute_dbval = Top50AttributeDbval.new
  end

  def create
    @top50_attribute = Top50Attribute.new(top50_attribute_dbval_params[:top50_attribute])
    @top50_attribute_dbval = Top50AttributeDbval.new(top50_attribute_dbval_params[:top50_attribute_dbval])
    @top50_attribute.save!
    @top50_attribute_dbval.id = @top50_attribute.id
    if @top50_attribute_dbval.save
      redirect_to :top50_attribute_dbvals
    else
      render :new
    end
  end

  def edit
    @top50_attribute_dbval = Top50AttributeDbval.includes(:top50_attribute).find(params[:id])
    @top50_attribute = @top50_attribute_dbval.top50_attribute
  end

  def update
    @top50_attribute = Top50Attribute.find(params[:id])
    @top50_attribute_dbval = Top50AttributeDbval.find(params[:id])
    @top50_attribute_dbval.update_attributes(top50_attribute_dbval_params[:top50_attribute_dbval])
    @top50_attribute.update_attributes(top50_attribute_dbval_params[:top50_attribute])
    redirect_to :top50_attribute_dbvals
  end

  def destroy
    @top50_attribute = Top50Attribute.find(params[:id])
    @top50_attribute.destroy
    redirect_to :top50_attribute_dbvals
  end



  def default
    Top50AttributeDbval.default!
  end

  private

  def top50_attribute_dbval_params
    params.require(:top50_attribute_dbval).permit(:top50_attribute_dbval => [:datatype_id], :top50_attribute => [:name, :name_eng, :attr_type])
  end

end

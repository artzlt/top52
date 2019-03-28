class Top50AttributeDictsController < Top50BaseController

  def index
    @top50_attributes_dict = Top50AttributeDict.includes(:top50_attribute).all
  end

  def show
    @top50_attribute = Top50Attribute.find(params[:id])
    @top50_attribute_dict = Top50AttributeDict.find(params[:id])
  end
 
  def new
    @top50_attribute = Top50Attribute.new
    @top50_attribute_dict = Top50AttributeDict.new
  end

  def create
    @top50_attribute = Top50Attribute.new(top50_attribute_dict_params[:top50_attribute])
    @top50_attribute_dict = Top50AttributeDict.new(top50_attribute_dict_params[:top50_attribute_dict])
    @top50_attribute.save!
    @top50_attribute_dict.id = @top50_attribute.id
    if @top50_attribute_dict.save
      redirect_to :top50_attribute_dicts
    else
      render :new
    end
  end

  def edit
    @top50_attribute_dict = Top50AttributeDict.includes(:top50_attribute).find(params[:id])
    @top50_attribute = @top50_attribute_dict.top50_attribute
  end

  def update
    @top50_attribute = Top50Attribute.find(params[:id])
    @top50_attribute_dict = Top50AttributeDict.find(params[:id])
    @top50_attribute_dict.update_attributes(top50_attribute_dict_params[:top50_attribute_dict])
    @top50_attribute.update_attributes(top50_attribute_dict_params[:top50_attribute])
    redirect_to :top50_attribute_dicts
  end

  def destroy
    @top50_attribute = Top50Attribute.find(params[:id])
    @top50_attribute.destroy
    redirect_to :top50_attribute_dicts
  end



  def default
    Top50AttributeDict.default!
  end

  private

  def top50_attribute_dict_params
    params.require(:top50_attribute_dict).permit(:top50_attribute_dict => [:dict_id], :top50_attribute => [:name, :name_eng, :attr_type])
  end

end

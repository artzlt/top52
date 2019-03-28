class Top50AttributeDatatypesController < Top50BaseController

  def index
    @top50_attribute_datatypes = Top50AttributeDatatype.all
  end

  def show
    @top50_attribute_datatype = Top50AttributeDatatype.find(params[:id])
  end
 
  def new
    @top50_attribute_datatype = Top50AttributeDatatype.new
  end

  def create
    @top50_attribute_datatype = Top50AttributeDatatype.new(top50attribute_datatype_params)
    if @top50_attribute_datatype.save
      redirect_to :top50_attribute_datatypes
    else
      render :new
    end
  end

  def edit
    @top50_attribute_datatype = Top50AttributeDatatype.find(params[:id])
  end

  def update
    @top50_attribute_datatype = Top50AttributeDatatype.find(params[:id])
    @top50_attribute_datatype.update_attributes(top50attribute_datatype_params)
    redirect_to :top50_attribute_datatypes
  end

  def destroy
    @top50_attribute_datatype = Top50AttributeDatatype.find(params[:id])
    @top50_attribute_datatype.destroy
    redirect_to :top50_attribute_datatypes
  end



  def default
    Top50AttributeDatatype.default!
  end

  private

  def top50attribute_datatype_params
    params.require(:top50_attribute_datatype).permit(:db_code)
  end
end

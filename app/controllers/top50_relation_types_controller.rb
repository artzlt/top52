class Top50RelationTypesController < Top50BaseController

  def index
    @top50_relation_types = Top50RelationType.all
  end

  def show
    @top50_relation_type = Top50RelationType.find(params[:id])
  end
 
  def new
    @top50_relation_type = Top50RelationType.new
  end

  def create
    @top50_relation_type = Top50RelationType.new(top50relation_type_params)
    @top50_relation_type[:is_valid] = 0
    @top50_relation_type[:comment] = "Added type"
    if @top50_relation_type.save
      redirect_to :top50_relation_types
    else
      render :new
    end
  end

  def edit
    @top50_relation_type = Top50RelationType.find(params[:id])
  end

  def update
    @top50_relation_type = Top50RelationType.find(params[:id])
    @top50_relation_type.update_attributes(top50relation_type_params)
    redirect_to :top50_relation_types
  end

  def destroy
    @top50_relation_type = Top50RelationType.find(params[:id])
    @top50_relation_type.destroy
    redirect_to :top50_relation_types
  end



  def default
    Top50RelationType.default!
  end

  private

  def top50relation_type_params
    params.require(:top50_relation_type).permit(:name, :name_eng)
  end
end

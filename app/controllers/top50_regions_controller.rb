class Top50RegionsController < Top50BaseController

  def index
    @top50_regions = Top50Region.all
  end

  def show
    @top50_region = Top50Region.find(params[:id])
  end
 
  def new
    @top50_region = Top50Region.new
  end

  def create
    @top50_region = Top50Region.new(top50region_params)
    @top50_region[:comment] = "Added region"
    if @top50_region.save
      redirect_to :back
    else
      render :new
    end
  end

  def edit
    @top50_region = Top50Region.find(params[:id])
  end

  def update
    @top50_region = Top50Region.find(params[:id])
    @top50_region.update_attributes(top50region_params)
    redirect_to :top50_regions
  end

  def destroy
    @top50_region = Top50Region.find(params[:id])
    @top50_region.destroy
    redirect_to :top50_regions
  end

  def default
    Top50Region.default!
  end

  private

  def top50region_params
    params.require(:top50_region).permit(:name, :name_eng, :country_id, :is_valid)
  end
end

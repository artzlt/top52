class Top50CitiesController < Top50BaseController

  def index
    @top50_cities = Top50City.all
  end

  def show
    @top50_city = Top50City.find(params[:id])
  end

  def format_regions
    @top50_regions = Top50Region.select("top50_regions.id, coalesce(top50_regions.name, 'Не указан') || ', ' || c.name as name")
      .joins("join top50_countries as c on c.id = top50_regions.country_id")
      .order("c.name, top50_regions.name")
  end
 
  def new
    @top50_city = Top50City.new
    format_regions
  end

  def create
    @top50_city = Top50City.new(top50city_params)
    @top50_city[:comment] = "Added city"
    if @top50_city.save
      redirect_to :back
    else
      render :new
    end
  end

  def edit
    @top50_city = Top50City.find(params[:id])
    format_regions
  end

  def update
    @top50_city = Top50City.find(params[:id])
    @top50_city.update_attributes(top50city_params)
    redirect_to :top50_cities
  end

  def destroy
    @top50_city = Top50City.find(params[:id])
    @top50_city.destroy
    redirect_to :top50_cities
  end

  def default
    Top50City.default!
  end

  private

  def top50city_params
    params.require(:top50_city).permit(:name, :name_eng, :region_id, :is_valid)
  end
end

class Top50CountriesController < Top50BaseController

  def index
    @top50_countries = Top50Country.all
  end

  def show
    @top50_country = Top50Country.find(params[:id])
  end
 
  def new
    @top50_country = Top50Country.new
  end

  def create
    @top50_country = Top50Country.new(top50country_params)
    @top50_country[:comment] = "Added country"
    if @top50_country.save
      redirect_to :back
    else
      render :new
    end
  end

  def edit
    @top50_country = Top50Country.find(params[:id])
  end

  def update
    @top50_country = Top50Country.find(params[:id])
    @top50_country.update_attributes(top50country_params)
    redirect_to :top50_countries
  end

  def destroy
    @top50_country = Top50Country.find(params[:id])
    @top50_country.destroy
    redirect_to :top50_countries
  end

  def default
    Top50Country.default!
  end

  private

  def top50country_params
    params.require(:top50_country).permit(:name, :name_eng, :is_valid)
  end
end

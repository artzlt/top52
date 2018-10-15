class Top50MeasureUnitsController < Top50BaseController

  def index
    @top50_measure_units = Top50MeasureUnit.all
  end

  def show
    @top50_measure_unit = Top50MeasureUnit.find(params[:id])
  end
 
  def new
    @top50_measure_unit = Top50MeasureUnit.new
  end

  def create
    @top50_measure_unit = Top50MeasureUnit.new(top50measure_unit_params)
    @top50_measure_unit[:is_valid] = 0
    @top50_measure_unit[:comment] = "Added type"
    if @top50_measure_unit.save
      redirect_to :top50_measure_units
    else
      render :new
    end
  end

  def edit
    @top50_measure_unit = Top50MeasureUnit.find(params[:id])
  end

  def update
    @top50_measure_unit = Top50MeasureUnit.find(params[:id])
    @top50_measure_unit.update_attributes(top50measure_unit_params)
    redirect_to :top50_measure_units
  end

  def destroy
    @top50_measure_unit = Top50MeasureUnit.find(params[:id])
    @top50_measure_unit.destroy
    redirect_to :top50_measure_units
  end



  def default
    Top50MeasureUnit.default!
  end

  private

  def top50measure_unit_params
    params.require(:top50_measure_unit).permit(:name, :name_eng, :asc_order)
  end
end

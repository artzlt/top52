class Top50MeasureScalesController < Top50BaseController

  def index
    @top50_measure_scales = Top50MeasureScale.all
  end

  def show
    @top50_measure_scale = Top50MeasureScale.find(params[:id])
  end
 
  def new
    @top50_measure_scale = Top50MeasureScale.new
  end

  def create
    @top50_measure_scale = Top50MeasureScale.new(top50measure_scale_params)
    @top50_measure_scale[:is_valid] = 0
    @top50_measure_scale[:comment] = "Added type"
    if @top50_measure_scale.save
      redirect_to :top50_measure_scales
    else
      render :new
    end
  end

  def edit
    @top50_measure_scale = Top50MeasureScale.find(params[:id])
  end

  def update
    @top50_measure_scale = Top50MeasureScale.find(params[:id])
    @top50_measure_scale.update_attributes(top50measure_scale_params)
    redirect_to :top50_measure_scales
  end

  def destroy
    @top50_measure_scale = Top50MeasureScale.find(params[:id])
    @top50_measure_scale.destroy
    redirect_to :top50_measure_scales
  end



  def default
    Top50MeasureScale.default!
  end

  private

  def top50measure_scale_params
    params.require(:top50_measure_scale).permit(:name, :name_eng, :scale, :measure_unit_id)
  end
end

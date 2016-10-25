class Top50MachineTypesController < ApplicationController

  def index
    @top50_machine_types = Top50MachineType.all
  end

  def show
    @top50_machine_type = Top50MachineType.find(params[:id])
  end
 
  def new
    @top50_machine_type = Top50MachineType.new
  end

  def create
    @top50_machine_type = Top50MachineType.new(top50machine_type_params)
    @top50_machine_type[:is_valid] = 0
    @top50_machine_type[:comment] = "Added type"
    if @top50_machine_type.save
      redirect_to :top50_machine_types
    else
      render :new
    end
  end

  def edit
    @top50_machine_type = Top50MachineType.find(params[:id])
  end

  def update
    @top50_machine_type = Top50MachineType.find(params[:id])
    @top50_machine_type.update_attributes(top50machine_type_params)
    redirect_to :top50_machine_types
  end

  def destroy
    @top50_machine_type = Top50MachineType.find(params[:id])
    @top50_machine_type.destroy
    redirect_to :top50_machine_types
  end



  def default
    Top50MachineType.default!
  end

  private

  def top50machine_type_params
    params.require(:top50_machine_type).permit(:name, :name_eng, :parent_id)
  end
end

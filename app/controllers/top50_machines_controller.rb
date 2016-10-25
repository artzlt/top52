class Top50MachinesController < ApplicationController

  def index
    @top50_machines = Top50Machine.all
  end

  def list
    #@top50_machines = Top50Machine.all.where(is_valid: 1)
    @top50_machines = Top50Machine.all
#    @ranked_list = @top50_machines.includes(Top50BenchmarkResult.all.joins(:top50_benchmark).merge(Top50Benchmark.where(name: "Linpack"))).order("top50_benchmark_results.result desc")
    @ranked_list = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(Top50Benchmark.where(name_eng: "Linpack")).joins(:top50_machine).merge(@top50_machines).order(result: :desc)
    cpu_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of CPUs"))
    @cpu_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(cpu_qty_attrs)
    core_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of cores"))
    @core_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(core_qty_attrs)
    rpeak_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Rpeak (MFlop/s)"))
    @rpeak_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(rpeak_attrs)
    com_net_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Communication network"))
    @com_net_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(com_net_attrs)
    serv_net_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Service network"))
    @serv_net_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(serv_net_attrs)
    tran_net_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Transport network"))
    @tran_net_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(tran_net_attrs)
    ram_size_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "RAM size (GB)"))
    @ram_size_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(ram_size_attrs)
    cpu_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "CPU model"))
    @cpu_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cpu_model_attrs)
    gpu_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "GPU model"))
    @gpu_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(gpu_model_attrs)
    @cpu_objects = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "CPU"))
    @gpu_objects = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "GPU"))

  end

  def benchmark_results
    @top50_machine = Top50Machine.find(params[:id])
  end

  def add_benchmark_result
    @top50_machine = Top50Machine.find(params[:id])
  end

  def create_benchmark_result
    @top50_machine = Top50Machine.find(params[:id])
    @top50_benchmark_result = @top50_machine.top50_benchmark_results.build(top50_benchmark_result_params)
    top50_br_obj = Top50Object.new
    top50_br_obj[:type_id] = 10
    top50_br_obj[:is_valid] = 0
    top50_br_obj[:comment] = "New Benchmark Result"
    top50_br_obj.save!
    @top50_benchmark_result.id = top50_br_obj.id
    if @top50_benchmark_result.save
      redirect_to :top50_machine_top50_benchmark_results
    else
      render :new_top50_machine_top50_benchmark_result
    end
  end

  def show
    @top50_machine = Top50Machine.find(params[:id])
  end
 
  def new
    @top50_machine = Top50Machine.new
  end

  def create
    @linked_obj = Top50Object.new
    @linked_obj[:type_id] = 1
    @linked_obj[:is_valid] = 0
    @linked_obj[:comment] = "NewMachine"
    @linked_obj.save!
    @top50_machine = Top50Machine.new(top50machine_params)
    @top50_machine.id = @linked_obj.id
    if @top50_machine.save
      redirect_to :top50_machines
    else
      render :new
    end
  end

  def edit
    @top50_machine = Top50Machine.find(params[:id])
  end

  def update
    @top50_machine = Top50Machine.find(params[:id])
    @top50_machine.update_attributes(top50machine_params)
    redirect_to :top50_machines
  end

  #def destroy
  #  @top50_machine = Top50Machine.find(params[:id])
  #  @top50_machine.destroy
  #end

  def destroy
    @top50_machine = Top50Machine.find(params[:id])
#    @linked_obj = Top50Object.find(params[:id])
#    @linked_obj.destroy
    @top50_machine.top50_object.destroy
    Top50Object.find(params[:id]).destroy
    Top50Object.delete_all(id: params[:id])
    #@linked_obj = Top50Object.new
    #@linked_obj[:type_id] = 1
    #@linked_obj[:is_valid] = params[:id]
    #@linked_obj[:comment] = "Del machine"
    #@linked_obj.save!

    @top50_machine.destroy
    redirect_to :top50_machines
  end



  def default
    Top50Machine.default!
    redirect_to :top50_machines
  end

  private

  def top50machine_params
    params.require(:top50_machine).permit(:name, :name_eng, :type_id, :vendor_id, :org_id, :contact_id, :website)
  end

  def top50_benchmark_result_params
    params.require(:top50_benchmark_result).permit(:benchmark_id, :result)
  end
end

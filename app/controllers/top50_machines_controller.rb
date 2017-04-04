	class Top50MachinesController < ApplicationController
  #skip_before_filter :require_login, only: [:list, :archive, :archive_lists, :vendor, :archive_by_vendor, :archive_by_org, :archive_by_vendor_excl, :archive_by_proc, :archive_by_gpu, :archive_by_cop, :archive_by_comp, :archive_by_comp_attrd, :archive_by_attr_dict, :show]
  def index
    @top50_machines = Top50Machine.all
  end

  def calc_machine_attrs
	
	list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @num_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
	list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
	
	@rmax_res = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(Top50Benchmark.where(name_eng: "Linpack"))
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
    app_area_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Application area"))
    @app_area_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(app_area_attrs)
    ram_size_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "RAM size (GB)"))
    @ram_size_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(ram_size_attrs)
    cpu_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "CPU model"))
    @cpu_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cpu_model_attrs)
    cpu_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "CPU Vendor"))
    @cpu_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cpu_vendor_attrs)
    gpu_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "GPU model"))
    @gpu_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(gpu_model_attrs)
	gpu_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "GPU Vendor"))
    @gpu_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(gpu_vendor_attrs)
	cop_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Coprocessor model"))
    @cop_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cop_model_attrs)
	cop_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Coprocessor Vendor"))
    @cop_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cop_vendor_attrs)
    @cop_objects = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Coprocessor"))
    @cpu_objects = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "CPU"))
    @gpu_objects = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "GPU"))
	@acc_objects = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Accelerator").first.top50_object_types)
	comp_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where("name_eng LIKE '% model'"))
    @comp_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(comp_model_attrs)
	comp_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where("name_eng LIKE '% Vendor'"))
    @comp_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(comp_vendor_attrs)
	nmax_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Linpack Nmax"))
    @nmax_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(nmax_attrs)
	prec_relation = Top50Relation.all.joins(:top50_relation_type).merge(Top50RelationType.where(name_eng: "Precedes"))
    @prec_machines = prec_relation.joins(:top50_object).merge(Top50Object.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Machine")))
	
	gpucore_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of GPU cores"))
    @gpucore_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(gpucore_qty_attrs)
    
	
  end
  
  def prepare_archive(edition_id)
    @bench = Top50Benchmark.find(edition_id)
    @rated_pos = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(Top50Benchmark.where(id: edition_id))
    ed_num = (@num_vals.find_by(obj_id: edition_id).value).to_i
	
    top50_bunch = Top50Object.find(2739)
	top50_lists = Top50Benchmark.select("top50_benchmarks.*").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch.id}")
	top50_prev1 = top50_lists.select("top50_benchmarks.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmarks.id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'")
	if ed_num == 1
	  ed_num = 2
	end
	top50_prev = top50_prev1.where("encode(top50_attribute_val_dbvals.value, 'escape') = '#{ed_num - 1}'").first
	@prev_rated_pos = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(Top50Benchmark.where(id: top50_prev.id))
  end
  
  def list_tmp
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	gpucore_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of GPU cores"))
    @gpucore_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(gpucore_qty_attrs)
    
	@top50_machines = Top50Machine.all.joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))
	
  end
  
  def list_tmp2
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	gpucore_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of GPU cores"))
    @gpucore_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(gpucore_qty_attrs)
    
	@top50_machines = Top50Machine.all.joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))
	
  end

  
  def list
    top50_bunch = Top50Object.find(2739)
	
	calc_machine_attrs
	
	top50_lists = Top50Benchmark.select("top50_benchmarks.*").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch.id}")
	top50_current = top50_lists.select("top50_benchmarks.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmarks.id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'").order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) desc").first
	
	prepare_archive(top50_current.id)
    #@rated_pos = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(Top50Benchmark.where(name_eng: "Top50 position (#24)"))
	
	@top50_machines = Top50Machine.all.joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))
  end

  def archive_lists
    top50_bunch = Top50Object.find(2739)
	#all_benchmarks = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Benchmark"))
	#@top50_lists = top50_bunch.top50_relations.select("top50_benchmarks.*").joins("top50_benchmarks on top50_benchmarks.id = top50_relations.sec_obj_id")
	@top50_lists = Top50Benchmark.select("top50_benchmarks.*").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch.id}")
	#@top50_lists = all_benchmarks.joins(:top50_object).merge(top50_bunch.top50_relations.joins(:top50_object))
	#@top50_lists = Top50Benchmark.all.where()
	list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @list_nums = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
	list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
	@top50_slists = @top50_lists.select("top50_benchmarks.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmarks.id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'").order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int)")
	
  end
	
  
  def archive
	
	calc_machine_attrs
	prepare_archive(params[:eid])
    
	@top50_machines = Top50Machine.all.joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))
	
  end
  
  
   def archive_by_vendor
   
	@vendor = Top50Vendor.find(params[:vid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("#{@vendor.id} = ANY(vendor_ids)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))
	
  end
  
  def archive_by_vendor_excl
   
	@vendor = Top50Vendor.find(params[:vid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("#{@vendor.id} = ALL(vendor_ids)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))
	
  end

  
  def archive_by_org
   
	@org = Top50Organization.find(params[:oid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("org_id in (select #{@org.id} union all select sec_obj_id from top50_relations a join top50_relation_types b on b.id = a.type_id and b.name_eng = 'Contains' where a.prim_obj_id = #{@org.id})").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))	
	
  end
  
  
  def archive_by_proc
   
	@proc = Top50Object.find(params[:oid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id join top50_relation_types c on c.id = a.type_id and c.id = b.type_id and c.name_eng = 'Contains' where b.sec_obj_id = #{@proc.id} and a.prim_obj_id = top50_machines.id)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))

	
  end
 
  
  def archive_by_gpu
   
	@gpu = Top50Object.find(params[:oid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id join top50_relation_types c on c.id = a.type_id and c.id = b.type_id and top50_relation_types.name_eng = 'Contains' where b.sec_obj_id = #{@gpu.id} and a.prim_obj_id = top50_machines.id)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))

	
  end
  
  def archive_by_cop
   
	@cop = Top50Object.find(params[:oid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id join top50_relation_types c on c.id = a.type_id and c.id = b.type_id and c.name_eng = 'Contains' where b.sec_obj_id = #{@cop.id} and a.prim_obj_id = top50_machines.id)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))

	
  end

  def archive_by_comp
   
	@comp = Top50Object.find(params[:oid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id join top50_relation_types c on c.id = a.type_id and c.id = b.type_id and c.name_eng = 'Contains' where b.sec_obj_id = #{@comp.id} and a.prim_obj_id = top50_machines.id)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))

	
  end  
  
  def archive_by_comp_attrd

    @dict_elem = Top50DictionaryElem.find(params[:elid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id join top50_relation_types c on c.id = a.type_id and c.id = b.type_id and c.name_eng = 'Contains' join top50_attribute_val_dicts d on d.obj_id = b.sec_obj_id where d.dict_elem_id = #{@dict_elem.id} and a.prim_obj_id = top50_machines.id)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))

	
  end  
  
  def archive_by_attr_dict
   
	@attr = Top50Attribute.find(params[:aid])
	@dict_elem = Top50DictionaryElem.find(params[:elid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.all.where("exists(select 1 from top50_attribute_val_dicts where dict_elem_id = #{@dict_elem.id} and obj_id = top50_machines.id)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))
	
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

  def tree_prec_sql(obj_id)
    "with recursive r as (
	 select prim_obj_id, sec_obj_id, rel.id, 1 as level
	 from top50_relations rel
	 join top50_relation_types rel_t on rel_t.id = rel.type_id and rel_t.name_eng = 'Precedes'
	 where sec_obj_id = #{obj_id}

	 union all

	 select rel.prim_obj_id, rel.sec_obj_id, rel.id, r.level + 1 as level
	 from top50_relations rel
	 join top50_relation_types rel_t on rel_t.id = rel.type_id and rel_t.name_eng = 'Precedes'
	 join r
	 on rel.sec_obj_id = r.prim_obj_id
	 )
	 select prim_obj_id from r
	 union all
	 select #{obj_id}"
  end
  
  
  def show
    @top50_machine = Top50Machine.find(params[:id])
	calc_machine_attrs
	
	name_eng_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Name(eng)"))
	top50_bunches_all = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Bunch of benchmarks"))
	top50_bunch_attr_name = (Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(name_eng_attrs)).joins(:top50_object).merge(top50_bunches_all).find_by(value: "Top50 position")
	@top50_lists = Top50Benchmark.select("top50_benchmarks.*").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}")
	list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @list_nums = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
	list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
	@top50_res = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(@top50_lists)
	@top50_incl = @top50_res.select("top50_benchmark_results.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmark_results.benchmark_id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'").where("top50_benchmark_results.machine_id IN (#{tree_prec_sql(@top50_machine.id)})").order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int)")
	
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

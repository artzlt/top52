# encoding: UTF-8
class Top50MachinesController < ApplicationController
  skip_before_filter :require_login, only: [:list, :archive, :archive_lists, :vendor, :archive_by_vendor, :archive_by_org, :archive_by_vendor_excl, :archive_by_proc, :archive_by_gpu, :archive_by_cop, :archive_by_comp, :archive_by_comp_attrd, :archive_by_attr_dict, :show, :stats, :ext_stats]
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
    
    @name_eng_attrid = Top50Attribute.where(name_eng: "Name(eng)").first.id
	@top50_bunch_id = Top50Object.select("top50_objects.id").
      joins("join top50_object_types on top50_object_types.id = top50_objects.type_id and top50_object_types.name_eng = 'Bunch of benchmarks'").
      joins("join top50_attribute_val_dbvals dbv on dbv.obj_id = top50_objects.id and dbv.attr_id = #{@name_eng_attrid} and dbv.value = 'Top50 position'").first.id
    @rel_contain_id = Top50RelationType.where(name_eng: 'Contains').first.id
    @top50_benchmarks = Top50Relation.where(prim_obj_id: @top50_bunch_id, type_id: @rel_contain_id).pluck(:sec_obj_id)
    @ed_num_attrid = Top50Attribute.where(name_eng: "Edition number").first.id
    @cpu_typeid = Top50ObjectType.where(name_eng: "CPU").first.id
    @acc_typeid = Top50ObjectType.where(name_eng: "Accelerator").first.id
    @acc_all_typeids = Top50ObjectType.where(parent_id: @acc_type_id).pluck(:id)
    @gpu_typeid = Top50ObjectType.where(name_eng: "GPU").first.id
    @cop_typeid = Top50ObjectType.where(name_eng: "Coprocessor").first.id
    @ram_size_attrid = Top50Attribute.where(name_eng: "RAM size (GB)").first.id
    @com_net_attrid = Top50Attribute.where(name_eng: "Communication network").first.id
    @serv_net_attrid = Top50Attribute.where(name_eng: "Service network").first.id
    @tran_net_attrid = Top50Attribute.where(name_eng: "Transport network").first.id
    @rpeak_attrid = Top50Attribute.where(name_eng: "Rpeak (MFlop/s)").first.id
    @app_area_attrid = Top50Attribute.where(name_eng: "Application area").first.id
    @cpu_qty_attrid = Top50Attribute.where(name_eng: "Number of CPUs").first.id
    @core_qty_attrid = Top50Attribute.where(name_eng: "Number of cores").first.id
    @gpucore_qty_attrid = Top50Attribute.where(name_eng: "Number of GPU cores").first.id
    @cpu_model_attrid = Top50Attribute.where(name_eng: "CPU model").first.id
    @cpu_vendor_attrid = Top50Attribute.where(name_eng: "CPU Vendor").first.id
    @gpu_model_attrid = Top50Attribute.where(name_eng: "GPU model").first.id
	@gpu_vendor_attrid = Top50Attribute.where(name_eng: "GPU Vendor").first.id
	@cop_model_attrid = Top50Attribute.where(name_eng: "Coprocessor model").first.id
	@cop_vendor_attrid = Top50Attribute.where(name_eng: "Coprocessor Vendor").first.id
    
  end
  
  def prepare_archive(edition_id)
    @bench = Top50Benchmark.find(edition_id)
    @rated_pos = Top50BenchmarkResult.where(benchmark_id: edition_id).order(result: :asc)
    ed_num = (Top50AttributeValDbval.where(attr_id: @ed_num_attrid, obj_id: edition_id).first.value).to_i

	if ed_num == 1
	  ed_num = 2
	end
    top50_prev_id = Top50AttributeValDbval.select("top50_attribute_val_dbvals.obj_id, encode(top50_attribute_val_dbvals.value, 'escape') as num").
      where(attr_id: @ed_num_attrid, obj_id: @top50_benchmarks, value: "#{ed_num - 1}").first.obj_id
	@prev_rated_pos = Top50BenchmarkResult.where(benchmark_id: top50_prev_id)
    
    @mach_x_l1 = Top50BenchmarkResult.select("top50_benchmark_results.machine_id as id, top50_benchmark_results.result as pos, ar.sec_obj_id as l1_id, ar.sec_obj_qty as l1_cnt, ao.type_id as l1_typeid").
      joins("join top50_relations ar on ar.prim_obj_id = top50_benchmark_results.machine_id and ar.type_id = #{@rel_contain_id}").
      joins("join top50_objects ao on ao.id = ar.sec_obj_id").
      where("top50_benchmark_results.benchmark_id = #{edition_id}").
      map(&:attributes)
    
    _nested_obj = Struct.new('NestedObject', :id, :type_id, :cnt)
    @mach_l1_hash = Hash.new{|h, k| h[k] = []}
    @l1_objects = []
    @mach_x_l1.each do |rec|
      @mach_l1_hash[rec["id"]] << _nested_obj.new(rec["l1_id"], rec["l1_typeid"], rec["l1_cnt"])
      @l1_objects << rec["l1_id"]
    end
    
    @l1_x_l2 = Top50Relation.select("top50_relations.prim_obj_id as l1_id, top50_relations.sec_obj_id as l2_id, top50_relations.sec_obj_qty as l2_cnt, o.type_id as l2_typeid").
      joins("join top50_objects o on o.id = top50_relations.sec_obj_id").
      where("top50_relations.type_id = #{@rel_contain_id} AND top50_relations.prim_obj_id IN (?)", @l1_objects).
      map(&:attributes)
    
    @l1_l2_hash = Hash.new{|h, k| h[k] = []}
    @l2_objects = []
    @l1_x_l2.each do |rec|
      @l1_l2_hash[rec["l1_id"]] << _nested_obj.new(rec["l2_id"], rec["l2_typeid"], rec["l2_cnt"])
      @l2_objects << rec["l2_id"]
    end
    
    @mach_x_attrd = Top50BenchmarkResult.select("top50_benchmark_results.machine_id as id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, dict_elems.id as elem_id, dict_elems.name as elem_name").
      joins("join top50_attribute_val_dicts avd on avd.obj_id = top50_benchmark_results.machine_id").
      joins("join top50_attributes on top50_attributes.id = avd.attr_id").
      joins("join top50_dictionary_elems dict_elems on dict_elems.id = avd.dict_elem_id").
      where("top50_benchmark_results.benchmark_id = #{edition_id}").
      map(&:attributes)
    
    _attrd_val = Struct.new('AttrDictValue', :attr_id, :attr_name, :elem_id, :elem_name)
    @mach_attrd_hash = Hash.new{|h, k| h[k] = []}
    @mach_x_attrd.each do |rec|
      @mach_attrd_hash[rec["id"]] << _attrd_val.new(rec["attr_id"], rec["attr_name"], rec["elem_id"], rec["elem_name"])
    end
    
    @mach_x_attrdb = Top50BenchmarkResult.select("top50_benchmark_results.machine_id as id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, avd.value").
      joins("join top50_attribute_val_dbvals avd on avd.obj_id = top50_benchmark_results.machine_id").
      joins("join top50_attributes on top50_attributes.id = avd.attr_id").
      where("top50_benchmark_results.benchmark_id = #{edition_id}").
      map(&:attributes)
      
    _attrdb_val = Struct.new('AttrDbValue', :attr_id, :attr_name, :value)
    @mach_attrdb_hash = Hash.new{|h, k| h[k] = []}
    @mach_x_attrdb.each do |rec|
      @mach_attrdb_hash[rec["id"]] << _attrdb_val.new(rec["attr_id"], rec["attr_name"], rec["value"])
    end
    
    @l1_x_attrd = Top50AttributeValDict.select("top50_attribute_val_dicts.obj_id as id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, dict_elems.id as elem_id, dict_elems.name as elem_name").
      joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dicts.attr_id").
      joins("join top50_dictionary_elems dict_elems on dict_elems.id = top50_attribute_val_dicts.dict_elem_id").
      where("top50_attribute_val_dicts.obj_id in (?)", @l1_objects).
      map(&:attributes)
    
    @l1_attrd_hash = Hash.new{|h, k| h[k] = []}
    @l1_x_attrd.each do |rec|
      @l1_attrd_hash[rec["id"]] << _attrd_val.new(rec["attr_id"], rec["attr_name"], rec["elem_id"], rec["elem_name"])
    end
    
    @l1_x_attrdb = Top50AttributeValDbval.select("top50_attribute_val_dbvals.obj_id as id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, top50_attribute_val_dbvals.value").
      joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id").
      where("top50_attribute_val_dbvals.obj_id in (?)", @l1_objects).
      map(&:attributes)

    @l1_attrdb_hash = Hash.new{|h, k| h[k] = []}
    @l1_x_attrdb.each do |rec|
      @l1_attrdb_hash[rec["id"]] << _attrdb_val.new(rec["attr_id"], rec["attr_name"], rec["value"])
    end
    
    @l2_x_attrd = Top50AttributeValDict.select("top50_attribute_val_dicts.obj_id as id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, dict_elems.id as elem_id, dict_elems.name as elem_name").
      joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dicts.attr_id").
      joins("join top50_dictionary_elems dict_elems on dict_elems.id = top50_attribute_val_dicts.dict_elem_id").
      where("top50_attribute_val_dicts.obj_id in (?)", @l2_objects).
      map(&:attributes)
    
    @l2_attrd_hash = Hash.new{|h, k| h[k] = []}
    @l2_x_attrd.each do |rec|
      @l2_attrd_hash[rec["id"]] << _attrd_val.new(rec["attr_id"], rec["attr_name"], rec["elem_id"], rec["elem_name"])
    end
    
    @l2_x_attrdb = Top50AttributeValDbval.select("top50_attribute_val_dbvals.obj_id as id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, top50_attribute_val_dbvals.value").
      joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id").
      where("top50_attribute_val_dbvals.obj_id in (?)", @l2_objects).
      map(&:attributes)

    @l2_attrdb_hash = Hash.new{|h, k| h[k] = []}
    @l2_x_attrdb.each do |rec|
      @l2_attrdb_hash[rec["id"]] << _attrdb_val.new(rec["attr_id"], rec["attr_name"], rec["value"])
    end
    
    
  end

  def list
  
	calc_machine_attrs
    
	top50_current_id = Top50AttributeValDbval.select("top50_attribute_val_dbvals.obj_id, encode(top50_attribute_val_dbvals.value, 'escape') as num").
      where(attr_id: @ed_num_attrid, obj_id: @top50_benchmarks).
      order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) desc").first.obj_id
	
	prepare_archive(top50_current_id)
    
    @top50_machines = Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{top50_current_id}").
      order("ed_results.result asc").
      map(&:attributes)
    
  end

  def archive_lists
    top50_bunch = Top50Object.find(2739)
	@top50_lists = Top50Benchmark.select("top50_benchmarks.*").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch.id}")
	list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @list_nums = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
	list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
	@top50_slists = @top50_lists.select("top50_benchmarks.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmarks.id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'").order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int)")
	
  end
	
  
  def archive
	
	calc_machine_attrs
	prepare_archive(params[:eid])
    
    @top50_machines = Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{params[:eid]}").
      order("ed_results.result asc").
      map(&:attributes)
	
  end
  
  
   def archive_by_vendor
   
	@vendor = Top50Vendor.find(params[:vid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
    @top50_machines = Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{params[:eid]}").
      where("#{@vendor.id} = ANY(top50_machines.vendor_ids)").
      order("ed_results.result asc").
      map(&:attributes)
	
  end
  
  def archive_by_vendor_excl
   
	@vendor = Top50Vendor.find(params[:vid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
    @top50_machines = Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{params[:eid]}").
      where("#{@vendor.id} = ALL(top50_machines.vendor_ids)").
      order("ed_results.result asc").
      map(&:attributes)
	
  end

  
  def archive_by_org
   
	@org = Top50Organization.find(params[:oid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
    
    @top50_machines = Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{params[:eid]}").
      where("top50_machines.org_id in (select #{@org.id} union all select sec_obj_id from top50_relations a where a.prim_obj_id = #{@org.id} and a.type_id = #{@rel_contain_id})").
      order("ed_results.result asc").
      map(&:attributes)
	
  end
  
  def archive_by_comp
   
	@comp = Top50Object.find(params[:oid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
    @top50_machines = Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{params[:eid]}").
      where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id where b.sec_obj_id = #{@comp.id} and a.prim_obj_id = top50_machines.id and a.type_id = #{@rel_contain_id} and b.type_id = #{@rel_contain_id})").
      order("ed_results.result asc").
      map(&:attributes)
	
  end  
  
  def archive_by_comp_attrd

    @dict_elem = Top50DictionaryElem.find(params[:elid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])
	
	@top50_machines = Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{params[:eid]}").
      where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id join top50_attribute_val_dicts d on d.obj_id = b.sec_obj_id where d.dict_elem_id = #{@dict_elem.id} and a.prim_obj_id = top50_machines.id and a.type_id = #{@rel_contain_id} and b.type_id = #{@rel_contain_id})").
      order("ed_results.result asc").
      map(&:attributes)
	
  end  
  
  def archive_by_attr_dict
   
	@attr = Top50Attribute.find(params[:aid])
	@dict_elem = Top50DictionaryElem.find(params[:elid])
	
	calc_machine_attrs
	prepare_archive(params[:eid])

	@top50_machines = Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{params[:eid]}").
      where("exists(select 1 from top50_attribute_val_dicts where dict_elem_id = #{@dict_elem.id} and obj_id = top50_machines.id)").
      order("ed_results.result asc").
      map(&:attributes)
	
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

  def stats_common
    name_eng_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Name(eng)"))
	top50_bunches_all = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Bunch of benchmarks"))
	top50_bunch_attr_name = (Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(name_eng_attrs)).joins(:top50_object).merge(top50_bunches_all).find_by(value: "Top50 position")
	@top50_lists = Top50Benchmark.all.joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}")

	@top50_slists = @top50_lists.select("top50_benchmarks.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmarks.id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'").order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) desc")
	
	all_res = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(@top50_lists)
    
    list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @num_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
	list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
    
  end
  
  def stats_per_list
    @list_id = params[:eid]
    stats(1)
    name_eng_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Name(eng)"))
	top50_bunches_all = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Bunch of benchmarks"))
	top50_bunch_attr_name = (Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(name_eng_attrs)).joins(:top50_object).merge(top50_bunches_all).find_by(value: "Top50 position")
    @top50_mtypes = Top50MachineType.all.select("top50_machine_types.id, top50_machine_types.name, count(1) cnt").joins("join top50_machines on top50_machine_types.id = top50_machines.type_id").joins("join top50_benchmark_results on top50_benchmark_results.machine_id = top50_machines.id").joins("join top50_benchmarks on top50_benchmarks.id = top50_benchmark_results.benchmark_id").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}").group("top50_machine_types.id, top50_machine_types.name").order("cnt desc").having("count(1) > 0")
  end
  
  
  
  def stats(ext = 0)
    @stat_section = params[:section]
    
    @section_headers = {}
    @section_headers["performance"] = "производительность систем"
    @section_headers["area"] = "область применения"
    @section_headers["type"] = "типы систем"
    @section_headers["hybrid_inter"] = "гибридность систем (наличие узлов разных типов)"
    @section_headers["hybrid_intra"] = "гибридности систем (наличие ускорителей на узлах)"
    @section_headers["vendors"] = "разработчики вычислительных систем"
    @section_headers["cpu_vendor"] = "производители CPU"
    @section_headers["cpu_fam"] = "типы CPU"
    @section_headers["cpu_gen"] = "поколения CPU"
    @section_headers["cpu_cnt"] = "количество CPU"
    @section_headers["core_cnt"] = "количество вычислительных ядер"
    @section_headers["comm_net"] = "коммуникационная сеть"
    
    @header_text = "Статистика: " + @section_headers["performance"]
    if @stat_section.present? 
      if @section_headers.has_key?(@stat_section)
        @header_text = "Статистика: " + @section_headers[@stat_section]
      elsif @stat_section[0..6] == 'vendors'
        @header_text = "Статистика: " + @section_headers["vendors"]
      end
    end
    
    if ext == 1
      _top50_cat = Struct.new('Top50Category', :id, :name)
    end
          
    list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @num_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
    list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
    name_eng_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Name(eng)"))
	top50_bunches_all = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Bunch of benchmarks"))
	top50_bunch_attr_name = (Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(name_eng_attrs)).joins(:top50_object).merge(top50_bunches_all).find_by(value: "Top50 position")
    rel_contain_id = Top50RelationType.where(name_eng: 'Contains').first.id
    top50_benchmarks = Top50Relation.where(prim_obj_id: top50_bunch_attr_name.obj_id, type_id: rel_contain_id).pluck(:sec_obj_id)
    @mach_approved = Top50BenchmarkResult.where(:benchmark_id => top50_benchmarks).pluck(:machine_id)
    if ext == 1
      @mach_approved = Top50BenchmarkResult.where(:benchmark_id => @list_id).pluck(:machine_id)
    end
    @top50_lists = Top50Benchmark.all.joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}")
	@top50_slists = @top50_lists.select("top50_benchmarks.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmarks.id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'").order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) desc")
    if @stat_section == 'hybrid_inter'
      comp_node_id = Top50ObjectType.where(name_eng: 'Compute node').first.id
      @hybrid_mach = Top50Machine.select("top50_machines.id").
        joins("join top50_relations r on r.prim_obj_id = top50_machines.id and r.type_id = #{rel_contain_id}").
        joins("join top50_objects o on o.id = r.sec_obj_id and o.type_id = #{comp_node_id}").
        group("top50_machines.id").
        having("count(1) >= 2").
        pluck("top50_machines.id")
    elsif @stat_section == 'hybrid_intra'
      acc_type_id = Top50ObjectType.where(name_eng: 'Accelerator').first.id
      acc_child_types = Top50ObjectType.where(parent_id: acc_type_id).pluck(:id)
      @hybrid_mach = Top50Machine.select("top50_machines.id").
        joins("join top50_relations ar on ar.prim_obj_id = top50_machines.id and ar.type_id = #{rel_contain_id}").
        joins("join top50_relations br on br.prim_obj_id = ar.sec_obj_id and br.type_id = #{rel_contain_id}").
        joins("join top50_objects o on o.id = br.sec_obj_id").
        where("o.type_id IN (?)", acc_child_types).
        pluck("distinct top50_machines.id")
    elsif @stat_section == 'cpu_vendor'
      cpu_vendor_dict_id = Top50Dictionary.where(name_eng: 'CPU Vendor').first.id
      @mach_x_cpuvendors = Top50DictionaryElem.all.select("top50_dictionary_elems.id, top50_dictionary_elems.name, top50_machines.id mach_id").
        joins("join top50_attribute_val_dicts on top50_attribute_val_dicts.dict_elem_id = top50_dictionary_elems.id").
        joins("join top50_machines on exists (
                select 1 from top50_relations ar join top50_relations br on br.prim_obj_id = ar.sec_obj_id 
                 where ar.prim_obj_id = top50_machines.id 
                   and br.sec_obj_id = top50_attribute_val_dicts.obj_id
                   and ar.type_id = #{rel_contain_id}
                   and br.type_id = #{rel_contain_id}
              )").
        where("top50_dictionary_elems.dict_id = #{cpu_vendor_dict_id}
           AND top50_machines.id IN (?)", @mach_approved).
        map(&:attributes)
      _cpuvendor = Struct.new('CPUVendor', :id, :name)
      @cpuvendor_id_hash = Hash.new{|h, k| h[k] = []}
      @top50_cpuvendors = []
      @mach_x_cpuvendors.each do |rec|
        if @cpuvendor_id_hash[rec["id"]].empty?
          @top50_cpuvendors << _cpuvendor.new(rec["id"], rec["name"])
        end
        @cpuvendor_id_hash[rec["id"]] << rec["mach_id"]
      end
    elsif @stat_section == 'cpu_fam' or @stat_section == 'cpu_gen'
      if @stat_section == 'cpu_fam'
        cpu_fam_dict_id = Top50Dictionary.where(name_eng: 'CPU families').first.id
        @chart_title = "Распределение систем по типам CPU"
      else
        cpu_fam_dict_id = Top50Dictionary.where(name_eng: 'CPU generations').first.id
        @chart_title = "Распределение систем по поколениям CPU"
      end
      @mach_x_cpufams = Top50DictionaryElem.all.select("top50_dictionary_elems.id fam_id, top50_dictionary_elems.name fam_name, top50_machines.id mach_id").
        joins("join top50_attribute_val_dicts on top50_attribute_val_dicts.dict_elem_id = top50_dictionary_elems.id").
        joins("join top50_machines on exists (
                select 1 from top50_relations ar join top50_relations br on br.prim_obj_id = ar.sec_obj_id 
                 where ar.prim_obj_id = top50_machines.id 
                   and br.sec_obj_id = top50_attribute_val_dicts.obj_id
                   and ar.type_id = #{rel_contain_id}
                   and br.type_id = #{rel_contain_id}
              )").
        where("top50_dictionary_elems.dict_id = #{cpu_fam_dict_id}
           AND top50_machines.id IN (?)", @mach_approved).
        map(&:attributes)
      _cpufam = Struct.new('CPUFam', :fam_id, :fam_name)
      @cpufam_id_hash = Hash.new{|h, k| h[k] = []}
      top50_cpufams_all = []
      @top50_cats_all = []
      @mach_x_cpufams.each do |rec|
        if @cpufam_id_hash[rec["fam_id"]].empty?
          top50_cpufams_all << _cpufam.new(rec["fam_id"], rec["fam_name"])
          if ext == 1
            @top50_cats_all << _top50_cat.new(rec["fam_id"], rec["fam_name"])
          end
        end
        @cpufam_id_hash[rec["fam_id"]] << rec["mach_id"]
      end
      sorted_cpufam_id_hash = @cpufam_id_hash.sort_by { |k, v| -v.size }
      @top50_cpufams = []
      sorted_cpufam_id_hash[1..10].each { |k| @top50_cpufams << top50_cpufams_all.find{|x| x.fam_id == k[0]} }
      if ext == 1        
        @sorted_cat_id_hash = sorted_cpufam_id_hash
        @top50_cat_id_hash = @cpufam_id_hash
        @top50_cats = []
        sorted_cpufam_id_hash[1..10].each do |k| 
          cpu_fam = top50_cpufams_all.find{|x| x.fam_id == k[0]}
          @top50_cats << _top50_cat.new(cpu_fam.fam_id, cpu_fam.fam_name)
        end
      end
      
    elsif @stat_section.present? and @stat_section[0..6] == 'vendors'
      @vendors_headers = {}
      @vendors_headers["vendors"] = "Количество систем"
      @vendors_headers["vendors_rmax"] = "Суммарная производительность Rmax (ПФлоп/с)"
      @vendors_headers["vendors_rpeak"] = "Суммарная производительность Rpeak (ПФлоп/с)"
      @vendors_headers["vendors_rmax_avg"] = "Средняя производительность Rmax (ПФлоп/с)"
      @vendors_headers["vendors_int"] = "Количество интеграторов"
      @vendors_headers["vendors_cnt_rmax"] = "Количество систем + Rmax (ПФлоп/с)"

      @vendors_header_text = @vendors_headers["vendors"]
      if @vendors_headers.has_key?(@stat_section)
        @vendors_header_text = @vendors_headers[@stat_section]
      end
      
      @top50_vendors = Top50Vendor.all.select("coalesce(v2.id, top50_vendors.id) as id, coalesce(v2.name, top50_vendors.name) as name, count(1) cnt").joins("left join (select prim_obj_id, sec_obj_id from top50_relations join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Precedes') pr_v on top50_vendors.id = pr_v.prim_obj_id").joins("left join top50_vendors v2 on v2.id = pr_v.sec_obj_id").joins("join top50_machines on top50_vendors.id = ANY(top50_machines.vendor_ids)").joins("join top50_benchmark_results on top50_benchmark_results.machine_id = top50_machines.id").joins("join top50_benchmarks on top50_benchmarks.id = top50_benchmark_results.benchmark_id").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}").group("coalesce(v2.id, top50_vendors.id), coalesce(v2.name, top50_vendors.name)").order("cnt desc").having("count(1) > 70")
	
	  prec_relation = Top50Relation.all.joins(:top50_relation_type).merge(Top50RelationType.where(name_eng: "Precedes"))
      @prec_vendors = prec_relation.joins(:top50_object).merge(Top50Object.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Vendor")))
    elsif  @stat_section == 'type'
      @top50_mtypes = Top50MachineType.all.select("top50_machine_types.id, top50_machine_types.name, count(1) cnt").joins("join top50_machines on top50_machine_types.id = top50_machines.type_id").joins("join top50_benchmark_results on top50_benchmark_results.machine_id = top50_machines.id").joins("join top50_benchmarks on top50_benchmarks.id = top50_benchmark_results.benchmark_id").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}").group("top50_machine_types.id, top50_machine_types.name").order("cnt desc").having("count(1) > 0")
    elsif  @stat_section == 'area'
      area_dict_id = Top50Dictionary.where(name_eng: 'Application areas').first.id
      @mach_x_areas = Top50DictionaryElem.all.select("top50_dictionary_elems.id area_id, top50_dictionary_elems.name area_name, top50_machines.id mach_id").
        joins("join top50_attribute_val_dicts on top50_attribute_val_dicts.dict_elem_id = top50_dictionary_elems.id").
        joins("join top50_machines on top50_machines.id = top50_attribute_val_dicts.obj_id").
        where("top50_dictionary_elems.dict_id = #{area_dict_id}
           AND top50_machines.id IN (?)", @mach_approved).
        map(&:attributes)
      _area = Struct.new('AppArea', :area_id, :area_name)
      @area_id_hash = Hash.new{|h, k| h[k] = []}
      @top50_areas = []
      @mach_x_areas.each do |rec|
        if @area_id_hash[rec["area_id"]].empty?
          @top50_areas << _area.new(rec["area_id"], rec["area_name"])
        end
        @area_id_hash[rec["area_id"]] << rec["mach_id"]
      end
    elsif @stat_section == 'cpu_cnt' or @stat_section == 'core_cnt'
      if @stat_section == 'cpu_cnt'
        cpu_typeid = Top50ObjectType.where(name_eng: "CPU").first.id
        c_qty_attrid = Top50Attribute.where(name_eng: "Number of CPUs").first.id
        @mach_x_ccnt = Top50Relation.select("top50_relations.prim_obj_id mach_id, sum(top50_relations.sec_obj_qty * l2r.sec_obj_qty) as c_cnt").
          joins("join top50_relations l2r on l2r.prim_obj_id = top50_relations.sec_obj_id and l2r.type_id = #{rel_contain_id}").
          joins("join top50_objects l2o on l2o.id = l2r.sec_obj_id and l2o.type_id = #{cpu_typeid}").
          where("top50_relations.type_id = #{rel_contain_id}
            AND top50_relations.prim_obj_id IN (?)", @mach_approved).
          group("top50_relations.prim_obj_id").
          map(&:attributes)
        up_bound = 8192
        low_bound = 8
      elsif @stat_section == 'core_cnt'
        core_qty_attrid = Top50Attribute.where(name_eng: "Number of cores").first.id
        c_qty_attrid = Top50Attribute.where(name_eng: "Number of cores").first.id
        @mach_x_ccnt = Top50Relation.select("top50_relations.prim_obj_id mach_id, sum(top50_relations.sec_obj_qty * l2r.sec_obj_qty * cast(encode(avd.value, 'escape') as int)) as c_cnt").
          joins("join top50_relations l2r on l2r.prim_obj_id = top50_relations.sec_obj_id and l2r.type_id = #{rel_contain_id}").
          joins("join top50_attribute_val_dbvals avd on avd.obj_id = l2r.sec_obj_id and avd.attr_id = #{core_qty_attrid}").
          where("top50_relations.type_id = #{rel_contain_id}
            AND top50_relations.prim_obj_id IN (?)", @mach_approved).
          group("top50_relations.prim_obj_id").
          map(&:attributes)
        up_bound = 65536
        low_bound = 8
      end
      attr_mach_x_ccnt = Top50AttributeValDbval.
          where(attr_id: c_qty_attrid, obj_id: @mach_approved).
          pluck(:obj_id, :value)
      @ccnt_id_hash = Hash.new{|h, k| h[k] = []}
      @top50_ccnts = []
      @top50_ccnts << "1-#{low_bound}"
      c_bound = low_bound
      while c_bound < up_bound
        @top50_ccnts << "#{c_bound + 1}-#{c_bound * 2}"
        c_bound *= 2
      end
      @top50_ccnts << "> #{up_bound}"
      @mach_approved.each do |mach|
        rec = @mach_x_ccnt.find{|x| x["mach_id"] == mach}
        c_cnt = 0
        if rec and rec["c_cnt"] > 0
          c_cnt = rec["c_cnt"]
        else
          attr_ccnt = attr_mach_x_ccnt.find{|x| x[0] == mach}
          if attr_ccnt
            c_cnt = attr_ccnt[1].to_i
          end
        end
        if c_cnt > 0
          if c_cnt > up_bound
            bucket = "> #{up_bound}"
          elsif c_cnt <= low_bound
            bucket = "1-#{low_bound}"
          else
            c_bound = up_bound
            until c_cnt > c_bound
              c_bound /= 2
            end
            bucket = "#{c_bound + 1}-#{c_bound * 2}"
          end
          @ccnt_id_hash[bucket] << mach
        end
      end
    elsif  @stat_section == 'comm_net'
      cnet_dict_id = Top50Dictionary.where(name_eng: 'Net families').first.id
      @mach_x_cnets = Top50DictionaryElem.all.select("top50_dictionary_elems.id cnet_id, top50_dictionary_elems.name cnet_name, top50_machines.id mach_id").
        joins("join top50_attribute_val_dicts on top50_attribute_val_dicts.dict_elem_id = top50_dictionary_elems.id").
        joins("join top50_machines on top50_machines.id = top50_attribute_val_dicts.obj_id").
        where("top50_dictionary_elems.dict_id = #{cnet_dict_id}
           AND top50_machines.id IN (?)", @mach_approved).
        map(&:attributes)
      _cnet = Struct.new('Cnet', :cnet_id, :cnet_name)
      @cnet_id_hash = Hash.new{|h, k| h[k] = []}
      @top50_cnets = []
      @mach_x_cnets.each do |rec|
        if @cnet_id_hash[rec["cnet_id"]].empty?
          @top50_cnets << _cnet.new(rec["cnet_id"], rec["cnet_name"])
        end
        @cnet_id_hash[rec["cnet_id"]] << rec["mach_id"]
      end
    end	
  end
  
  def ext_stats
    stats_common
    @edition_id = params[:eid]
    name_eng_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Name(eng)"))
	top50_bunches_all = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Bunch of benchmarks"))
	top50_bunch_attr_name = (Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(name_eng_attrs)).joins(:top50_object).merge(top50_bunches_all).find_by(value: "Top50 position")
    @top50_mtypes = Top50MachineType.all.select("top50_machine_types.id, top50_machine_types.name, count(1) cnt").joins("join top50_machines on top50_machine_types.id = top50_machines.type_id").joins("join top50_benchmark_results on top50_benchmark_results.machine_id = top50_machines.id").joins("join top50_benchmarks on top50_benchmarks.id = top50_benchmark_results.benchmark_id").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}").group("top50_machine_types.id, top50_machine_types.name").order("cnt desc").having("count(1) > 0")
    
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

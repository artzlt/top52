# encoding: UTF-8
class Top50MachinesController < Top50BaseController
  skip_before_filter :require_login, only: [:list, :get_archive, :get_archive_by_vendor, :get_archive_by_org, :get_archive_by_city, :get_archive_by_country, :get_archive_by_vendor_excl, :get_archive_by_comp, :get_archive_by_comp_attrd, :get_archive_by_attr_dict, :archive, :archive_lists, :archive_by_vendor, :archive_by_org, :archive_by_city, :archive_by_country, :archive_by_vendor_excl, :archive_by_comp, :archive_by_comp_attrd, :archive_by_attr_dict, :show, :stats, :get_ext_stats, :ext_stats, :get_stats_per_list, :stats_per_list, :download_certificate, :app_form_new, :app_form_new_post, :app_form_upgrade, :app_form_upgrade_post, :app_form_step1, :app_form_step1_presave, :app_form_step2_presave, :app_form_step3_presave, :app_form_step4_presave, :app_form_confirm_post, :app_form_finish]
  skip_before_filter :require_admin_rights, only: [:list, :get_archive, :get_archive_by_vendor, :get_archive_by_org, :get_archive_by_city, :get_archive_by_country, :get_archive_by_vendor_excl, :get_archive_by_comp, :get_archive_by_comp_attrd, :get_archive_by_attr_dict, :archive, :archive_lists, :archive_by_vendor, :archive_by_org, :archive_by_city, :archive_by_country, :archive_by_vendor_excl, :archive_by_comp, :archive_by_comp_attrd, :archive_by_attr_dict, :show, :stats, :get_ext_stats, :ext_stats, :get_stats_per_list, :stats_per_list, :download_certificate, :app_form_new, :app_form_new_post, :app_form_upgrade, :app_form_upgrade_post, :app_form_step1, :app_form_step1_presave, :app_form_step2_presave, :app_form_step3_presave, :app_form_step4_presave, :app_form_confirm_post, :app_form_finish]
  def index
    @top50_machines = Top50Machine.all
  end

  def download_certificate
    if params[:path] and params[:path].start_with?("public/cert_create/certificates")
      send_file params[:path], filename: "Certificate.pdf", type:"application/pdf"
    else
      redirect_to :back
    end
  end

  def get_rel_contain_id
    return Top50RelationType.where(name_eng: 'Contains').first.id
  end

  def get_rel_precede_id
    return Top50RelationType.where(name_eng: 'Precedes').first.id
  end

  def get_name_eng_attr_id
    return Top50Attribute.where(name_eng: "Name(eng)").first.id
  end

  def get_preview_bunch_id
    return Top50Object.select("top50_objects.id").
      joins("join top50_object_types on top50_object_types.id = top50_objects.type_id and top50_object_types.name_eng = 'Bunch of benchmarks'").
      joins("join top50_attribute_val_dbvals dbv on dbv.obj_id = top50_objects.id and dbv.attr_id = #{get_name_eng_attr_id} and dbv.value = 'Top50 preview'").first.id
  end

  def get_bunch_id
    return Top50Object.select("top50_objects.id").
      joins("join top50_object_types on top50_object_types.id = top50_objects.type_id and top50_object_types.name_eng = 'Bunch of benchmarks'").
      joins("join top50_attribute_val_dbvals dbv on dbv.obj_id = top50_objects.id and dbv.attr_id = #{get_name_eng_attr_id} and dbv.value = 'Top50 position'").first.id
  end

  def get_avail_bunches
    res = [get_bunch_id]
    if current_user and current_user.may_preview?
      res << get_preview_bunch_id
    end
    return res
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
    node_platform_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Node platform"))
    @node_platform_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(node_platform_attrs)
    node_platform_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Node platform Vendor"))
    @node_platform_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(node_platform_vendor_attrs)

    microcore_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of micro cores"))
    @microcore_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(microcore_qty_attrs)
    
    @name_eng_attrid = get_name_eng_attr_id
    @rel_contain_id = get_rel_contain_id
    @top50_bunch_id = get_bunch_id
    @top50_preview_bunch_id = get_preview_bunch_id
    @top50_benchmarks = Top50Relation.where(prim_obj_id: get_avail_bunches, type_id: @rel_contain_id).pluck(:sec_obj_id)
    @top50_published_benchmarks = Top50Relation.where(prim_obj_id: @top50_bunch_id, type_id: @rel_contain_id).pluck(:sec_obj_id)
    @top50_preview_benchmarks = Top50Relation.where(prim_obj_id: @top50_preview_bunch_id, type_id: @rel_contain_id).pluck(:sec_obj_id)
    @ed_num_attrid = Top50Attribute.where(name_eng: "Edition number").first.id
    @ed_date_attrid = Top50Attribute.where(name_eng: "Edition date").first.id
    @cpu_typeid = Top50ObjectType.where(name_eng: "CPU").first.id
    @acc_typeid = Top50ObjectType.where(name_eng: "Accelerator").first.id
    @acc_all_typeids = Top50ObjectType.where(parent_id: @acc_typeid).pluck(:id)
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
    @microcore_qty_attrid = Top50Attribute.where(name_eng: "Number of micro cores").first.id
    @cpu_model_attrid = Top50Attribute.where(name_eng: "CPU model").first.id
    @cpu_vendor_attrid = Top50Attribute.where(name_eng: "CPU Vendor").first.id
    @gpu_model_attrid = Top50Attribute.where(name_eng: "GPU model").first.id
    @gpu_vendor_attrid = Top50Attribute.where(name_eng: "GPU Vendor").first.id
    @cop_model_attrid = Top50Attribute.where(name_eng: "Coprocessor model").first.id
    @cop_vendor_attrid = Top50Attribute.where(name_eng: "Coprocessor Vendor").first.id
    @rmax_benchid = Top50Benchmark.where(name_eng: "Linpack").first.id
    @place_measureid = Top50MeasureUnit.where(name_eng: 'place').first.id
    @perf_measureid = Top50MeasureUnit.where(name_eng: 'MFlop/s').first.id
    @node_platform_attrid = Top50Attribute.where(name_eng: "Node platform").first.id
    @node_platform_vendor_attrid = Top50Attribute.where(name_eng: "Node platform Vendor").first.id
    
  end
  
  def prepare_archive(edition_id)
    @bench = Top50Benchmark.find(edition_id)
    date_attr = @date_vals.find_by(obj_id: @bench.id)
    ldate = date_attr.value
    @list_year = ldate.split(".")[2]
    @list_month = ldate.split(".")[1]
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

    @mach_x_bench = Top50BenchmarkResult.select("top50_benchmark_results.machine_id as id, b.id as benchmark_id, b.name as benchmark_name, br.result, mu.id as measure_id, mu.name as measure_name").
      joins("join top50_benchmark_results br on br.machine_id = top50_benchmark_results.machine_id").
      joins("join top50_benchmarks b on b.id = br.benchmark_id").
      joins("join top50_measure_units mu on mu.id = b.measure_id").
      where("top50_benchmark_results.benchmark_id = #{edition_id}").
      map(&:attributes)

    _bench_res = Struct.new('BenchResult', :benchmark_id, :benchmark_name, :result, :measure_id, :measure_name)
    @mach_bench_hash = Hash.new{|h, k| h[k] = []}
    @mach_x_bench.each do |rec|
      @mach_bench_hash[rec["id"]] << _bench_res.new(rec["benchmark_id"], rec["benchmark_name"], rec["result"], rec["measure_id"], rec["measure_name"])
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

  def new_list
    top50_lists = get_top50_lists.pluck(:id)
    list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @list_nums = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
    list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
    @top50_slists = Top50Benchmark.where("name_eng like 'Top50 position%' and id not in (?)", top50_lists).order("updated_at, created_at")

    calc_machine_attrs
    if params.include?(:id)
      top50_current_id = params[:id].to_i
      @editing = true
      @ed_num = (Top50AttributeValDbval.where(attr_id: @ed_num_attrid, obj_id: top50_current_id).first.value).to_i
      @pdate = Date.strptime(Top50AttributeValDbval.where(attr_id: @ed_date_attrid, obj_id: top50_current_id).first.value, '%d.%m.%Y')
      top50_prev = Top50AttributeValDbval.select("top50_attribute_val_dbvals.obj_id, encode(top50_attribute_val_dbvals.value, 'escape') as num").
        where("attr_id = ? and obj_id in (?) and cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) < ?", @ed_num_attrid, @top50_benchmarks, @ed_num).
        order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) desc").first
      if top50_prev.present?
        top50_prev_id = top50_prev.obj_id
      else
        top50_prev_id = 0
      end
      @bench = Top50Benchmark.find(top50_current_id)
    else
      top50_prev = Top50AttributeValDbval.select("top50_attribute_val_dbvals.obj_id, encode(top50_attribute_val_dbvals.value, 'escape') as num").
        where(attr_id: @ed_num_attrid, obj_id: @top50_benchmarks).
        order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) desc").first
      if top50_prev.present?
        top50_prev_id = top50_prev.obj_id
      else
        top50_prev_id = 0
      end

      @ed_num = (Top50AttributeValDbval.where(attr_id: @ed_num_attrid, obj_id: top50_prev_id).first.value).to_i + 1
      if params.include?(:list_date)
        @pdate = Date.parse(params[:list_date])
      else
        @pdate = Date.today
      end
      @bench = Top50Benchmark.find(top50_prev_id)
    end

    @prev_rated_pos = Top50BenchmarkResult.where(benchmark_id: top50_prev_id)
    
    @mach_x_l1 = Top50Machine.select("top50_machines.id as id, 0 as pos, top50_machines.is_valid as status, ar.sec_obj_id as l1_id, ar.sec_obj_qty as l1_cnt, ao.type_id as l1_typeid").
      joins("join top50_relations ar on ar.prim_obj_id = top50_machines.id and ar.type_id = #{@rel_contain_id}").
      joins("join top50_objects ao on ao.id = ar.sec_obj_id").
      where("top50_machines.is_valid > 0").
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
    
    @mach_x_attrd = Top50Machine.select("top50_machines.id as id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, dict_elems.id as elem_id, dict_elems.name as elem_name").
      joins("join top50_attribute_val_dicts avd on avd.obj_id = top50_machines.id").
      joins("join top50_attributes on top50_attributes.id = avd.attr_id").
      joins("join top50_dictionary_elems dict_elems on dict_elems.id = avd.dict_elem_id").
      where("top50_machines.is_valid > 0").
      map(&:attributes)
    
    _attrd_val = Struct.new('AttrDictValue', :attr_id, :attr_name, :elem_id, :elem_name)
    @mach_attrd_hash = Hash.new{|h, k| h[k] = []}
    @mach_x_attrd.each do |rec|
      @mach_attrd_hash[rec["id"]] << _attrd_val.new(rec["attr_id"], rec["attr_name"], rec["elem_id"], rec["elem_name"])
    end
    
    @mach_x_attrdb = Top50Machine.select("top50_machines.id as id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, avd.value").
      joins("join top50_attribute_val_dbvals avd on avd.obj_id = top50_machines.id").
      joins("join top50_attributes on top50_attributes.id = avd.attr_id").
      where("top50_machines.is_valid > 0").
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
    
    if params.include?(:id)
      @rated_pos_hash = Top50BenchmarkResult.where(benchmark_id: top50_current_id).map(&:attributes)
      @top50_machines = Top50Machine.select("top50_machines.*, ed_results.result, 1 as in_top50").
        joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{@rmax_benchid}").
        order("ed_results.result desc").
        where("(top50_machines.is_valid > 0 and (top50_machines.start_date is null or top50_machines.start_date <= '#{@pdate}') and (top50_machines.end_date is null or top50_machines.end_date > '#{@pdate}')) or top50_machines.id in (?)", @rated_pos_hash.collect{ |x| x['machine_id'] }).
        limit(50).
        map(&:attributes)
      @top50_machines.concat(Top50Machine.select("top50_machines.*, ed_results.result, 0 as in_top50").
        joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{@rmax_benchid}").
        order("ed_results.result desc").
        where("((top50_machines.is_valid > 1 and (top50_machines.start_date is null or top50_machines.start_date <= '#{@pdate}') and (top50_machines.end_date is null or top50_machines.end_date > '#{@pdate}')) or top50_machines.id in (?)) and top50_machines.id not in (?)", @rated_pos_hash.collect{ |x| x['machine_id'] }, @top50_machines.collect{ |x| x['id'] }).
        map(&:attributes)
      )
    else    
      @top50_machines = Top50Machine.select("top50_machines.*, ed_results.result, 1 as in_top50").
        joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{@rmax_benchid}").
        order("ed_results.result desc").
        where("top50_machines.is_valid > 0 and (top50_machines.start_date is null or top50_machines.start_date <= '#{@pdate}') and (top50_machines.end_date is null or top50_machines.end_date > '#{@pdate}')").
        limit(50).
        map(&:attributes)
      @top50_machines.concat(Top50Machine.select("top50_machines.*, coalesce(ed_results.result, 0) as result, 0 as in_top50").
        joins("left join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{@rmax_benchid}").
        order("coalesce(ed_results.result, 0) desc").
        where("(top50_machines.is_valid > 1 and (top50_machines.start_date is null or top50_machines.start_date <= '#{@pdate}') and (top50_machines.end_date is null or top50_machines.end_date > '#{@pdate}')) and top50_machines.id not in (?)", @top50_machines.collect{ |x| x['id'] }).
        map(&:attributes)
      )
    end
  end

  def submit_list_fail(err_msg)
    flash[:error] = err_msg
    new_list
    render :new_list
    return
  end
  
  def admin_links
  end

  def moderate
    if params.include?(:id)
      @top50_machine = Top50Machine.find(params[:id].to_i)
      if @top50_machine.contact_id.present?
        @contact = Top50Contact.find(@top50_machine.contact_id)
      end
      @rel_contain_id = get_rel_contain_id
      @nodes = Top50Relation.select("top50_relations.id as rel_id, ao.id as id, 0 as fake_id, top50_relations.sec_obj_qty as cnt, ao.type_id as type_id, 1 as existing").
        joins("join top50_objects ao on ao.id = top50_relations.sec_obj_id").
        where("top50_relations.prim_obj_id = #{@top50_machine.id} and top50_relations.type_id = #{@rel_contain_id}").
        map(&:attributes)
        
      @comps = Top50Relation.select("top50_relations.id as rel_id, top50_relations.prim_obj_id as node_id, 0 as fake_node_id, ao.id as id, 0 as fake_id, top50_relations.sec_obj_qty as cnt, ao.type_id as type_id, 1 as existing").
        joins("join top50_objects ao on ao.id = top50_relations.sec_obj_id").
        where("top50_relations.type_id = #{@rel_contain_id} AND top50_relations.prim_obj_id IN (?)", @nodes.collect{ |x| x['id'] }).
        map(&:attributes)

      all_obj_ids = [@top50_machine.id] + @nodes.collect{ |x| x['id'] } + @comps.collect{ |x| x['id'] }

      all_obj_x_attrd = Top50AttributeValDict.select("top50_attribute_val_dicts.obj_id as obj_id, 0 as fake_obj_id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, dict_elems.id as elem_id, dict_elems.name as elem_name, 1 as existing").
        joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dicts.attr_id").
        joins("join top50_dictionary_elems dict_elems on dict_elems.id = top50_attribute_val_dicts.dict_elem_id").
        where("top50_attribute_val_dicts.obj_id in (?)", all_obj_ids).
        map(&:attributes)
      
      all_obj_x_attrdb = Top50AttributeValDbval.select("top50_attribute_val_dbvals.obj_id as obj_id, 0 as fake_obj_id, top50_attributes.id as attr_id, top50_attributes.name as attr_name, top50_attribute_val_dbvals.value, 1 as existing").
        joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id").
        where("top50_attribute_val_dbvals.obj_id in (?)", all_obj_ids).
        map(&:attributes)
      
      @mach_x_attrd = all_obj_x_attrd.select{ |x| x['obj_id'] == @top50_machine.id }
      @nodes_x_attrd =  all_obj_x_attrd.select{ |x| (@nodes.collect{ |y| y['id'] }).include?(x['obj_id']) }
      @comps_x_attrd = all_obj_x_attrd.select{ |x| (@comps.collect{ |y| y['id'] }).include?(x['obj_id']) }
   
      @mach_x_attrdb = all_obj_x_attrdb.select{ |x| x['obj_id'] == @top50_machine.id }
      @nodes_x_attrdb =  all_obj_x_attrdb.select{ |x| (@nodes.collect{ |y| y['id'] }).include?(x['obj_id']) }
      @comps_x_attrdb = all_obj_x_attrdb.select{ |x| (@comps.collect{ |y| y['id'] }).include?(x['obj_id']) }
      
      @cpu_typeid = Top50ObjectType.where(name_eng: "CPU").first.id
      @acc_typeid = Top50ObjectType.where(name_eng: "Accelerator").first.id
      @acc_all_typeids = Top50ObjectType.where(parent_id: @acc_typeid).pluck(:id)
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
      @microcore_qty_attrid = Top50Attribute.where(name_eng: "Number of micro cores").first.id
      @cpu_model_attrid = Top50Attribute.where(name_eng: "CPU model").first.id
      @cpu_vendor_attrid = Top50Attribute.where(name_eng: "CPU Vendor").first.id
      @gpu_model_attrid = Top50Attribute.where(name_eng: "GPU model").first.id
      @gpu_vendor_attrid = Top50Attribute.where(name_eng: "GPU Vendor").first.id
      @cop_model_attrid = Top50Attribute.where(name_eng: "Coprocessor model").first.id
      @cop_vendor_attrid = Top50Attribute.where(name_eng: "Coprocessor Vendor").first.id

      @prev_machine_ids = Top50Relation.where(sec_obj_id: @top50_machine.id, type_id: get_rel_precede_id).pluck(:prim_obj_id)

    else
      @top50_machine = Top50Machine.new
    end

  end

  def set_attr(o, k, v)
    if v.present?
      o[k] = v
    else
      o[k] = nil
    end
  end
    

  def set_attrs_from_hash(o, h)
    h.each do |k, v|
      set_attr(o, k, v)
    end
  end

  def pre_save
    @obj_to_destroy = params['obj_to_destroy']
    if not @obj_to_destroy.present?
      @obj_to_destroy = []
    end
    moderate
    set_attrs_from_hash(@top50_machine, params['machine'])
    if params.include? 'contact'
      if not @contact.present?
        @contact = Top50Contact.new
      end
      set_attrs_from_hash(@contact, params['contact'])
    end
    case params[:commit]
    when 'Добавить контактное лицо'
      @contact = Top50Contact.new
    when 'Удалить контактное лицо'
      if @contact.id.present?
        @contact.destroy
        @top50_machine[:contact_id] = nil
      end
      @contact = nil
    when 'Добавить группу узлов'
      @nodes.append({
        'rel_id' => nil,
        'id' => nil,
        'fake_id' => nil,
        'cnt' => 0,
        'type_id' => Top50ObjectType.where(name_eng: "CPU").first.id,
        'existing' => 0
      })      
    end
    @top50_machine.save!
    render :moderate
    return
  end

  def change
  end

  def add_preview_list
    list = Top50Benchmark.find(params[:id])
    Top50Relation.create(
      type_id: get_rel_contain_id,
      prim_obj_id: get_preview_bunch_id,
      sec_obj_id: list.id,
    )
    redirect_to proc { top50_machines_archive_path(list.id) }
  end

  def delete_preview_list
    list = Top50Benchmark.find(params[:id])
    r = Top50Relation.find_by(
      type_id: get_rel_contain_id,
      prim_obj_id: get_preview_bunch_id,
      sec_obj_id: list.id,
    )
    if r.present?
      r.destroy
    end
    redirect_to proc { top50_machines_archive_path(list.id) }
  end

  def publish_list
    list = Top50Benchmark.find(params[:id])
    r = Top50Relation.find_by(
      type_id: get_rel_contain_id,
      prim_obj_id: get_preview_bunch_id,
      sec_obj_id: list.id,
    )
    if r.present?
      r.destroy
    end
    Top50Relation.create(
      type_id: get_rel_contain_id,
      prim_obj_id: get_bunch_id,
      sec_obj_id: list.id,
    )
    redirect_to proc { top50_machines_archive_path(list.id) }
  end

  def unpublish_list
    list = Top50Benchmark.find(params[:id])
    r = Top50Relation.find_by(
      type_id: get_rel_contain_id,
      prim_obj_id: get_bunch_id,
      sec_obj_id: list.id,
    )
    if r.present?
      r.destroy
    end
    redirect_to proc { top50_machines_archive_path(list.id) }
  end

  def destroy_list
    list = Top50Benchmark.find(params[:id])
    list.destroy
    redirect_to :top50_machines_archive_lists
  end

  def submit_list
    flash.delete(:error)
    @pdate = Date.parse(params[:list_date])
    @ldate = @pdate.strftime("%d.%m.%Y")
    @new_ed_num = params[:list_num].to_i
    @pos_hash = params['pos']
    @status_hash = params['status']
    res_hash = {}
    if params['commit'] == 'Подтверждаю'
      params['status'].each do |id, val|
        if not [1, 3, 0].include? val.to_i
          submit_list_fail('При подтверждении списка все системы должны иметь статус 0, 1 или 3')
          return
        end
        if val.to_i == 3 and params['pos'][id].to_i <= 0
          submit_list_fail('Системе со статусом 3 должно быть присвоено место в списке! (от 1 до 50)')
          return
        end
      end
          
      params['pos'].each do |id, val|
        pos = val.to_i 
        if pos < 0 or pos > 50
          submit_list_fail(format('Позиция системы в списке не может иметь значние %d', pos))
          return
        end
        if pos > 0
          if res_hash.has_key? pos
            submit_list_fail(format('Позиция %d присвоена нескольким системам!', pos))
            return
          end
          if not [1, 3].include? params['status'][id].to_i
            submit_list_fail(format('Система с позицией %d не может иметь статус %d', pos, params['status'][id].to_i))
            return
          end
          t = Top50BenchmarkResult.new
          t[:machine_id] = id
          t[:result] = pos
          t[:is_valid] = 1
          t[:comment] = format('Top50 place for edition %d', @new_ed_num)
          res_hash[pos] = t
        end
      end

      for i in 1..50
        if not res_hash.has_key? i
          submit_list_fail(format('Позиция %d не присвоена ни одной из систем!', i))
          return
        end
      end

      ed_num_attrid = Top50Attribute.where(name_eng: "Edition number").first.id
      ed_date_attrid = Top50Attribute.where(name_eng: "Edition date").first.id
      if params.include?(:id)
        @list_id = params[:id]
        Top50AttributeValDbval.where({ attr_id: ed_num_attrid, obj_id: @list_id }).delete_all
        Top50AttributeValDbval.where({ attr_id: ed_date_attrid, obj_id: @list_id }).delete_all
      else
        n_list = Top50Benchmark.new 
        n_list[:comment] = format('New Top50 list no. %d by %s', @new_ed_num, @ldate)
        n_list[:name] = format('Позиция в Top50 (#%d)', @new_ed_num)
        n_list[:name_eng] = format('Top50 position (#%d)', @new_ed_num)
        n_list[:is_valid] = 1
        n_list[:measure_id] = Top50MeasureUnit.where(name_eng: 'place').first.id
        n_list.save!
        
        @list_id = n_list.id
      end
      ed_attr = Top50AttributeValDbval.new
      ed_attr[:attr_id] = ed_num_attrid
      ed_attr[:obj_id] = @list_id
      ed_attr[:value] = format('%d', @new_ed_num)
      ed_attr[:is_valid] = 1


      d_attr = Top50AttributeValDbval.new
      d_attr[:attr_id] = ed_date_attrid
      d_attr[:obj_id] = @list_id
      d_attr[:value] = @ldate
      d_attr[:is_valid] = 1

      if not ed_attr.save or not d_attr.save
        if n_list.present?
          n_list.destroy
        end
        raise 'Attribute setting failed!'
      end

      if not params.include?(:id)
        res_hash.each do |k, v|
          v[:benchmark_id] = n_list.id
          if not v.save
            n_list.destroy
            raise 'Result saving failed!'
          end
        end
      end
    end

    params['status'].each do |id, value|
      mach = Top50Machine.find(id.to_i)
      if mach.is_valid != value.to_i
        mach.update(is_valid: value.to_i)
      end
    end

    if params['commit'] == 'Обновить статусы'
      redirect_to proc { top50_machines_new_list_with_date_path(@pdate.to_s(:db)) }
      return
    end

  end

  def get_top50_lists
    return Top50Benchmark.select("top50_benchmarks.*").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").where("top50_relations.prim_obj_id in (?) and top50_relations.type_id = ?", get_avail_bunches, get_rel_contain_id)
  end 

  def get_top50_lists_sorted
    top50_lists = get_top50_lists
    ed_num_attrid = Top50Attribute.where(name_eng: "Edition number").first.id
    return top50_lists.select("top50_benchmarks.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmarks.id").where("top50_attribute_val_dbvals.attr_id = ?", ed_num_attrid).order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) desc")
  end

  def archive_lists
    @top50_lists = get_top50_lists
    list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @list_nums = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
    list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
    @top50_slists = get_top50_lists_sorted
  end
  
  def get_list_id_by_date(year, month)
    ed_date_attrid = Top50Attribute.where(name_eng: "Edition date").first.id
    attr = Top50AttributeValDbval.find_by("attr_id = ? and obj_id in (?) and value like '__.#{month}.#{year}'", ed_date_attrid, get_top50_lists.pluck(:id))
    if attr.present?
      return attr.obj_id
    else
      return 0
    end
  end

  def fetch_archive_list(list_id)
    if current_user and current_user.may_edit_top50?
      list = Top50Benchmark.find(list_id)
    else
      avail_lists = get_top50_lists
      list = avail_lists.find(list_id)
    end
    calc_machine_attrs
    prepare_archive(list.id)
    return Top50Machine.select("top50_machines.*, ed_results.result").
      joins("join top50_benchmark_results ed_results on ed_results.machine_id = top50_machines.id and ed_results.benchmark_id = #{list.id}")
  end

  def archive_common(list_id)
    @top50_machines = fetch_archive_list(list_id).
      order("ed_results.result asc").
      map(&:attributes)
  end
 
  def get_archive
    year = params[:year]
    month = params[:month]
    archive_common(get_list_id_by_date(year, month))
    render :archive
    return
  end

  def archive
    eid = params[:eid].to_i
    archive_common(eid)
  end
    
    
  def archive_by_vendor_common(list_id)
    @vendor = Top50Vendor.find(params[:vid])
    @top50_machines = fetch_archive_list(list_id).
      where("#{@vendor.id} = ANY(top50_machines.vendor_ids)").
      order("ed_results.result asc").
      map(&:attributes)
  end

  def get_archive_by_vendor
    year = params[:year]
    month = params[:month]
    archive_by_vendor_common(get_list_id_by_date(year, month))
    render :archive_by_vendor
    return
  end

  def archive_by_vendor
    eid = params[:eid].to_i
    archive_by_vendor_common(eid)
  end
    
  def archive_by_vendor_excl_common(list_id)
    @vendor = Top50Vendor.find(params[:vid])
    @top50_machines = fetch_archive_list(list_id).
      where("#{@vendor.id} = ALL(top50_machines.vendor_ids)").
      order("ed_results.result asc").
      map(&:attributes)
  end

  def get_archive_by_vendor_excl
    year = params[:year]
    month = params[:month]
    archive_by_vendor_excl_common(get_list_id_by_date(year, month))
    render :archive_by_vendor_excl
    return
  end

  def archive_by_vendor_excl
    eid = params[:eid].to_i
    archive_by_vendor_excl_common(eid)
  end
    
  def archive_by_org_common(list_id)
    @org = Top50Organization.find(params[:oid])
    @top50_machines = fetch_archive_list(list_id).
      where("top50_machines.org_id in (select #{@org.id} union all select sec_obj_id from top50_relations a where a.prim_obj_id = #{@org.id} and a.type_id = #{get_rel_contain_id})").
      order("ed_results.result asc").
      map(&:attributes)
  end

  def get_archive_by_org
    year = params[:year]
    month = params[:month]
    archive_by_org_common(get_list_id_by_date(year, month))
    render :archive_by_org
    return
  end

  def archive_by_org
    eid = params[:eid].to_i
    archive_by_org_common(eid)
  end

  def archive_by_city_common(list_id)
    @city = Top50City.find(params[:cid])
    @top50_machines = fetch_archive_list(list_id).
      where("top50_machines.org_id in (select id from top50_organizations a where a.city_id = #{@city.id})").
      order("ed_results.result asc").
      map(&:attributes)
  end

  def get_archive_by_city
    year = params[:year]
    month = params[:month]
    archive_by_city_common(get_list_id_by_date(year, month))
    render :archive_by_city
    return
  end

  def archive_by_city
    eid = params[:eid].to_i
    archive_by_city_common(eid)
  end
  
  def archive_by_country_common(list_id)
    @country = Top50Country.find(params[:cid])
    @top50_machines = fetch_archive_list(list_id).
      where("top50_machines.org_id in (select a.id from top50_organizations a join top50_cities b on a.city_id = b.id join top50_regions c on b.region_id = c.id where c.country_id = #{@country.id})").
      order("ed_results.result asc").
      map(&:attributes)
  end

  def get_archive_by_country
    year = params[:year]
    month = params[:month]
    archive_by_country_common(get_list_id_by_date(year, month))
    render :archive_by_country
    return
  end

  def archive_by_country
    eid = params[:eid].to_i
    archive_by_country_common(eid)
  end
   
  def archive_by_comp_common(list_id)
    @comp = Top50Object.find(params[:oid])
    @top50_machines = fetch_archive_list(list_id).
      where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id where b.sec_obj_id = #{@comp.id} and a.prim_obj_id = top50_machines.id and a.type_id = #{get_rel_contain_id} and b.type_id = #{get_rel_contain_id})").
      order("ed_results.result asc").
      map(&:attributes)
  end

  def get_archive_by_comp
    year = params[:year]
    month = params[:month]
    archive_by_comp_common(get_list_id_by_date(year, month))
    render :archive_by_comp
    return
  end

  def archive_by_comp
    eid = params[:eid].to_i
    archive_by_comp_common(eid)
  end
    
  def archive_by_comp_attrd_common(list_id)
    @dict_elem = Top50DictionaryElem.find(params[:elid])
    @top50_machines = fetch_archive_list(list_id).
      where("exists(select 1 from top50_relations a join top50_relations b on b.prim_obj_id = a.sec_obj_id join top50_attribute_val_dicts d on d.obj_id = b.sec_obj_id where d.dict_elem_id = #{@dict_elem.id} and a.prim_obj_id = top50_machines.id and a.type_id = #{get_rel_contain_id} and b.type_id = #{get_rel_contain_id})").
      order("ed_results.result asc").
      map(&:attributes)
  end

  def get_archive_by_comp_attrd
    year = params[:year]
    month = params[:month]
    archive_by_comp_attrd_common(get_list_id_by_date(year, month))
    render :archive_by_comp_attrd
    return
  end

  def archive_by_comp_attrd
    eid = params[:eid].to_i
    archive_by_comp_attrd_common(eid)
  end
    
  def archive_by_attr_dict_common(list_id)
    @attr = Top50Attribute.find(params[:aid])
    @dict_elem = Top50DictionaryElem.find(params[:elid])
    @top50_machines = fetch_archive_list(list_id).
      where("exists(select 1 from top50_attribute_val_dicts where dict_elem_id = #{@dict_elem.id} and obj_id = top50_machines.id and attr_id = #{@attr.id})").
      order("ed_results.result asc").
      map(&:attributes)
  end

  def get_archive_by_attr_dict
    year = params[:year]
    month = params[:month]
    archive_by_attr_dict_common(get_list_id_by_date(year, month))
    render :archive_by_attr_dict
    return
  end

  def archive_by_attr_dict
    eid = params[:eid].to_i
    archive_by_attr_dict_common(eid)
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
    if @top50_benchmark_result.save
      redirect_to proc { top50_machine_top50_benchmark_results_path(@top50_machine.id) }
    else
      render :new_top50_machine_top50_benchmark_result
    end
  end

  def edit_benchmark_result
    @top50_benchmark_result = Top50BenchmarkResult.find(params[:brid])
    @top50_machine = Top50Machine.find(params[:id])
  end

  def save_benchmark_result
    @top50_benchmark_result = Top50BenchmarkResult.find(params[:brid])
    @top50_machine = Top50Machine.find(params[:id])
    @top50_benchmark_result.update(top50_benchmark_result_params)
    @top50_benchmark_result.save!
    redirect_to proc { top50_machine_top50_benchmark_results_path(@top50_machine.id) }
  end

  def destroy_benchmark_result
    @top50_benchmark_result = Top50BenchmarkResult.find(params[:brid])
    @top50_machine = Top50Machine.find(params[:id])
    @top50_benchmark_result.destroy!
    redirect_to proc { top50_machine_top50_benchmark_results_path(@top50_machine.id) }
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
    if current_user and current_user.may_preview?
      @top50_machine = Top50Machine.find(params[:id])
    else
      @top50_machine = Top50Machine.where(is_valid: 1).find(params[:id])
    end
    calc_machine_attrs
    @perf_measured_attrs = [@rpeak_attrid]

    @top50_lists = get_top50_lists
    list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @list_nums = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
    list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
    @top50_res = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(@top50_lists)
    @top50_incl = @top50_res.select("top50_benchmark_results.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmark_results.benchmark_id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'").where("top50_benchmark_results.machine_id IN (#{tree_prec_sql(@top50_machine.id)})").order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int)")

  end

  def stats_common

    @top50_lists = get_top50_lists
    @top50_slists = get_top50_lists_sorted

    all_res = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(@top50_lists)
    
    list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @num_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
    list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
    
  end
  
  def stats_per_list_common(eid)
    @list_id = get_top50_lists.find(eid).id
    stats(1)
    @top50_mtypes = get_avail_mtypes
  end

  def get_stats_per_list
    stats_per_list_common(get_list_id_by_date(params[:year], params[:month]))
    render :stats_per_list
    return
  end

  def stats_per_list
    stats_per_list_common(params[:eid].to_i)
  end
  
  def stats(ext = 0)
    @stat_section = params[:section]
    
    @section_headers = {}
    @section_headers["performance"] = "производительность систем"
    @section_headers["area"] = "область применения"
    @section_headers["city"] = "расположение систем"
    @section_headers["type"] = "типы систем"
    @section_headers["hybrid_inter"] = "гибридность систем (количество узлов разных типов)"
    @section_headers["hybrid_intra"] = "гибридность систем (наличие ускорителей на узлах)"
    @section_headers["vendors"] = "разработчики вычислительных систем"
    @section_headers["cpu_vendor"] = "производители CPU"
    @section_headers["cpu_fam"] = "семейства CPU"
    @section_headers["cpu_gen"] = "микроархитектура CPU"
    @section_headers["cpu_cnt"] = "количество CPU"
    @section_headers["core_cnt"] = "количество вычислительных ядер"
    @section_headers["comm_net"] = "семейства коммуникационных сетей"
    @section_headers["comm_net_sep"] = "коммуникационные сети"
    
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
    rel_contain_id = get_rel_contain_id
    top50_benchmarks = Top50Relation.where(prim_obj_id: get_avail_bunches, type_id: rel_contain_id).pluck(:sec_obj_id)
    @mach_approved = Top50BenchmarkResult.where(:benchmark_id => top50_benchmarks).pluck(:machine_id)
    if ext == 1
      @mach_approved = Top50BenchmarkResult.where(:benchmark_id => @list_id).pluck(:machine_id)
    end
    @top50_lists = get_top50_lists
    @top50_slists = get_top50_lists_sorted
    if @stat_section == 'hybrid_inter'
      comp_node_id = Top50ObjectType.where(name_eng: 'Compute node').first.id
      @hybrid_mach = {}
      machines = Top50Machine.select("top50_machines.id").
          joins("join top50_relations r on r.prim_obj_id = top50_machines.id and r.type_id = #{rel_contain_id}").
          joins("join top50_objects o on o.id = r.sec_obj_id and o.type_id = #{comp_node_id}").
          group("top50_machines.id")
      (1..20).each do |i|
        ids = machines.having("count(1) = #{i}").
          pluck("top50_machines.id")
        if ids.count > 0
          @hybrid_mach[i] = ids
        end
      end
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
        @chart_title = "Распределение систем по микроархитектурам CPU"
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
      
      @top50_vendors = Top50Vendor.all.select("coalesce(v2.id, top50_vendors.id) as id, coalesce(v2.name, top50_vendors.name) as name, count(1) cnt").joins("left join (select prim_obj_id, sec_obj_id from top50_relations join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Precedes') pr_v on top50_vendors.id = pr_v.prim_obj_id").joins("left join top50_vendors v2 on v2.id = pr_v.sec_obj_id").joins("join top50_machines on top50_vendors.id = ANY(top50_machines.vendor_ids)").joins("join top50_benchmark_results on top50_benchmark_results.machine_id = top50_machines.id").joins("join top50_benchmarks on top50_benchmarks.id = top50_benchmark_results.benchmark_id").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id IN (?)", get_avail_bunches).group("coalesce(v2.id, top50_vendors.id), coalesce(v2.name, top50_vendors.name)").order("cnt desc").having("count(1) > 70")

      prec_relation = Top50Relation.all.joins(:top50_relation_type).merge(Top50RelationType.where(name_eng: "Precedes"))
      @prec_vendors = prec_relation.joins(:top50_object).merge(Top50Object.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Vendor")))
    elsif  @stat_section == 'type'
      @top50_mtypes = get_avail_mtypes 
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
    elsif  @stat_section == 'city'
      @mach_x_cities = Top50City.all.select("top50_cities.id, top50_cities.name, top50_machines.id mach_id").
        joins("join top50_organizations o on o.city_id = top50_cities.id").
        joins("join top50_machines on top50_machines.org_id = o.id").
        where("top50_machines.id IN (?)", @mach_approved).
        map(&:attributes)
      @city_id_hash = Hash.new{|h, k| h[k] = []}
      @top50_cities = []
      @mach_x_cities.each do |rec|
        if @city_id_hash[rec["id"]].empty?
          @top50_cities << Top50City.find_by(id: rec["id"])
        end
        @city_id_hash[rec["id"]] << rec["mach_id"]
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
    elsif @stat_section == 'comm_net'
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
    elsif @stat_section == 'comm_net_sep'
      comm_net_attrid = Top50Attribute.where(name_eng: "Communication network").first.id
      @mach_x_cnets = Top50DictionaryElem.all.select("top50_dictionary_elems.id cnet_id, top50_dictionary_elems.name cnet_name, top50_machines.id mach_id").
       joins("join top50_attribute_val_dicts on top50_attribute_val_dicts.dict_elem_id = top50_dictionary_elems.id").
       joins("join top50_machines on top50_machines.id = top50_attribute_val_dicts.obj_id").
       where("top50_attribute_val_dicts.attr_id = #{comm_net_attrid}
          AND top50_machines.id IN (?)", @mach_approved).
       map(&:attributes)
        
      _cnet = Struct.new('Cnet', :cnet_id, :cnet_name)
      @cnet_id_hash = Hash.new{|h, k| h[k] = []}
      @top50_cnets = []
      @pop_cnets = {}
      @mach_x_cnets.each do |rec|
        if @cnet_id_hash[rec["cnet_id"]].empty?
          @top50_cnets << _cnet.new(rec["cnet_id"], rec["cnet_name"])
          @pop_cnets[rec["cnet_name"]] = false
        end
        @cnet_id_hash[rec["cnet_id"]] << rec["mach_id"]
      end

      @top50_slists.each do |list|
        @top50_cnets.each do |cnet|
          c_cnt = Top50BenchmarkResult.where("benchmark_id = #{list.id} AND machine_id IN (?)", @cnet_id_hash[cnet.cnet_id]).count
          if c_cnt > 2
            @pop_cnets[cnet.cnet_name] = true
          end
        end
      end
      @pop_cnets.each do |key, value|
        if !value
          @top50_cnets.delete_if{|el| el.cnet_name == key}
        end
      end
    end
  end

  def get_avail_mtypes
    return Top50MachineType.select("top50_machine_types.id, top50_machine_types.name, count(1) cnt").joins("join top50_machines on top50_machine_types.id = top50_machines.type_id").joins("join top50_benchmark_results on top50_benchmark_results.machine_id = top50_machines.id").joins("join top50_benchmarks on top50_benchmarks.id = top50_benchmark_results.benchmark_id").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").where("top50_relations.prim_obj_id IN (?) and top50_relations.type_id = ?", get_avail_bunches, get_rel_contain_id).group("top50_machine_types.id, top50_machine_types.name").order("cnt desc").having("count(1) > 0")
  end

  def ext_stats_common(eid)
    stats_common
    @edition_id = get_top50_lists.find(eid).id
    @top50_mtypes = get_avail_mtypes
  end

  def ext_stats
    ext_stats_common(params[:eid].to_i)
  end

  def get_ext_stats
    ext_stats_common(get_list_id_by_date(params[:year], params[:month]))
    render :ext_stats
    return
  end

  def new
    @top50_machine = Top50Machine.new
  end

  def create
    @top50_machine = Top50Machine.new(top50machine_params)
    @top50_machine[:comment] = "Added system"
    if @top50_machine.save
      redirect_to :back
    else
      render :new
    end
  end

  def edit
    @top50_machine = Top50Machine.find(params[:id])
  end

  def update
    @top50_machine = Top50Machine.find(params[:id])
    vendor_ids = params[:top50_machine][:vendor_ids]
    vendor_ids.delete("")
    vendor_ids.collect! {|x| x.to_i}
    if params[:top50_machine][:vendor_id].present?
      vendor_ids = ([params[:top50_machine][:vendor_id].to_i] + vendor_ids).uniq
    end
    @top50_machine.vendor_ids = vendor_ids
    @top50_machine.update_attributes(top50machine_params)
    redirect_to :top50_machines
  end

  def destroy
    @top50_machine = Top50Machine.find(params[:id])
    @top50_machine.destroy
    redirect_to :top50_machines
  end
  
  def prepare_arch_attrs
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
  end
  
  def add_component
    @comp_node_type = Top50ObjectType.where(name_eng: 'Compute node').first
    @top50_machine = Top50Machine.find(params[:id])
    @top50_object = Top50Object.find(params[:id])
    @top50_nested_object = Top50Object.new
    @top50_relation = Top50Relation.new
    @cpu_dict_id = Top50Dictionary.where(name_eng: 'CPU model').first.id
    @gpu_dict_id = Top50Dictionary.where(name_eng: 'GPU model').first.id
    @cop_dict_id = Top50Dictionary.where(name_eng: 'Coprocessor model').first.id
    
    prepare_arch_attrs
  end

  def create_component
    @rel_contain_id = get_rel_contain_id
    @comp_node_id = Top50ObjectType.where(name_eng: 'Compute node').first.id
    @cpu_typeid = Top50ObjectType.where(name_eng: 'CPU').first.id
    @gpu_type_id = Top50ObjectType.where(name_eng: 'GPU').first.id
    @cop_type_id = Top50ObjectType.where(name_eng: 'Coprocessor').first.id
    
    @top50_machine = Top50Machine.find(params[:id])
    @top50_object = Top50Object.find(params[:id])
    
    top50_relation = @top50_object.top50_relations.build(top50_node_params[:top50_node])
    top50_relation.type_id = get_rel_contain_id
    top50_nested_node = Top50Object.new
    top50_nested_node.type_id = @comp_node_id
    top50_nested_node.is_valid = top50_node_params[:top50_node][:is_valid]
    top50_relation.sec_obj_id = top50_nested_node.id
    if top50_node_params[:top50_cpu][:sec_obj_qty].present? and top50_node_params[:top50_cpu][:sec_obj_qty].to_i > 0
        top50_cpu_relation = top50_nested_node.top50_relations.build
        top50_cpu_relation.sec_obj_qty = top50_node_params[:top50_cpu][:sec_obj_qty]
        top50_cpu_relation.is_valid = top50_node_params[:top50_cpu][:is_valid]
        top50_cpu_id = Top50AttributeValDict.where(dict_elem_id: top50_node_params[:top50_cpu][:model_dict_elem_id]).first.obj_id
        top50_cpu_relation.type_id = @rel_contain_id
        top50_cpu_relation.sec_obj_id = top50_cpu_id
    end
    if top50_node_params[:top50_acc][:sec_obj_qty].present? and top50_node_params[:top50_acc][:sec_obj_qty].to_i > 0
        top50_acc_relation = top50_nested_node.top50_relations.build
        top50_acc_relation.sec_obj_qty = top50_node_params[:top50_acc][:sec_obj_qty]
        top50_acc_relation.is_valid = top50_node_params[:top50_acc][:is_valid]
        top50_acc_id = Top50AttributeValDict.where(dict_elem_id: top50_node_params[:top50_acc][:model_dict_elem_id]).first.obj_id
        top50_acc_relation.type_id = @rel_contain_id
        top50_acc_relation.sec_obj_id = top50_acc_id
    end
    
    top50_ram_attr = top50_nested_node.top50_attribute_val_dbvals.build
    @ram_size_attrid = Top50Attribute.where(name_eng: "RAM size (GB)").first.id
    top50_ram_attr.attr_id = @ram_size_attrid
    top50_ram_attr.value = top50_node_params[:top50_ram][:ram_size]
    top50_ram_attr.is_valid = top50_node_params[:top50_ram][:is_valid]
    
    redirect_to top50_machines_app_form_step2_url
  end

  helper_method :ext_url

  def ext_url(s)
    if s.downcase.start_with? "http"
      return s
    else
      return "http://" + s
    end
  end

  def default
    Top50Machine.default!
    redirect_to :top50_machines
  end
  
  helper_method :get_cur

  def get_cur(param)
    if @cur_data.present?
      return @cur_data.fetch(param, nil)
    end
  end

  helper_method :get_cur2

  def get_cur2(param, nested_param)
    if @cur_data.present?
      return @cur_data.fetch(param, {}).fetch(nested_param, nil)
    end
  end

  helper_method :is_focused

  def is_focused(k, k2)
    if @focus_fields.present?
      return @focus_fields.fetch([k, k2], false)
    end
    return false
  end

  def fetch_cur_data
    params.reject {|k,v| ["step1_data", "step2_data", "step3_data", "step4_data"].include? k}
  end

  def fetch_by_sym(data_sym)
    params.fetch(:sym, nil) == data_sym.to_s ? fetch_cur_data : params.fetch(data_sym, {})
  end

  def fetch_all_data_from_params
    @step1_data = fetch_by_sym(:step1_data)
    @step2_data = fetch_by_sym(:step2_data)
    @step3_data = fetch_by_sym(:step3_data) 
    @step4_data = fetch_by_sym(:step4_data)
  end

  def check_param(p_name, cd, data_errs)
    if cd.keys.any? {|x| params.has_key? x}
      cd.keys.each do |k|
        if cd[k].is_a? Hash
          cd[k].keys.each do |k2|
            if not params.fetch(k, {}).fetch(k2, nil).present?
              data_errs.append(cd[k][k2])
            end
          end
        else
          if not params.fetch(k, nil).present?
            data_errs.append(cd[k])
          end
        end
      end
    else
      data_errs.append(p_name)
    end  
  end

  def validate_req_params(step)
    req_params = {
      step1: {
        vendor_id: "Основной производитель системы",
        installation_date: "Год установки вычислительной системы",
        type_id: "Тип вычислительной системы",
        org_id: "Организация (место установки системы)",
        custom_suborg: {
          name: "Название подразделения",
          name_eng: "Название подразделения на английском языке",
          country: "Страна, в которой расположено подразделение",
          city: "Город расположения подразделения"
        },
        contact: {
          surname: "Фамилия контактного лица",
          name: "Имя контактного лица",
          email: "Email контактного лица"
        }
      },
      step2: {
      },
      step3: {
        app_area: {
          app_dict_elem_id: "Область применения вычислительной системы"
        },
        nets: {
          comm_net_dict_elem_id: "Основная коммуникационная (вычислительная) сеть",
          tplg_dict_elem_id: "Топология коммуникационной сети"
        }
      },
      step4: {
        top50_perf: {
          rpeak: "Rpeak",
          rmax: "Rmax",
          msize: "Размер матрицы, на котором было достигнута указанная производительность"
        }
      }
    }
    custom_req_params = {
      step1: {
        vendor_id: {
          custom_vendor: {
            name: "Название производителя",
            name_eng: "Название производителя на английском языке"
          }
        },
        type_id: {
          custom_type: {
            name: "Название типа системы",
            name_eng: "Название типа системы на английском языке"
          }
        },
        org_id: {
          custom_org: {
            name: "Название организации",
            name_eng: "Название организации на английском языке",
            country: "Страна, в которой расположена организация",
            city: "Город расположения организации"
          }
        }
      },
      step3: {
        app_area: {
          app_dict_elem_id: {
            app_area: {
              custom_app: "Область применения вычислительной системы"
            }
          }
        },
        nets: {
          comm_net_dict_elem_id: {
            nets: {
              custom_comm_net: "Основная коммуникационная (вычислительная) сеть"
            }
          },
          tplg_dict_elem_id: {
            nets: {
              custom_tplg: "Топология коммуникационной сети"
            }
          }
        }
      }
    }
    data_errs = []
    data = req_params.fetch(step, {})
    custom_data = custom_req_params.fetch(step, {})
    case step
    when :step1
      if params[:org_id].present? and params[:suborg_id].present?
        if not Top50Relation.where(type_id: get_rel_contain_id, prim_obj_id: params[:org_id].to_i).pluck(:sec_obj_id).include? params[:suborg_id].to_i
          return "Выбранное подразделение не соответствует организации"
        end
      end
      add_vendors = params.select {|k,v| k.starts_with? 'add_vendor_'}
      data.update(add_vendors.merge(add_vendors) {
        |k,v,x| {
          name: "Название участвующего производителя",
          name_eng: "Название участвующего производителя на английском языке"
        }
      })
    when :step2
      if params[:node_group_cnt].to_i == 0
        return "Не указано ни одной группы узлов вычислительной системы"
      end
      node_groups = params.select {|k,v| k.starts_with? 'top50_node_'}
      node_groups.keys.each do |node|
        data[node] = {
          node_cnt: "Количество вычислительных узлов в группе",
          ram_size: "Объем оперативной памяти"
        }
        custom_data[node] = {}
        if params[node][:cpu_model_obj_id].present? or params[node][:custom_cpu_from_node].present? or params[node][:custom_cpu_model].present?
          data[node].update({
            cpu_cnt: "Количество процессоров на одном узле"
          })
        end
        if params[node][:custom_cpu_model].present?
          data[node].update({
            custom_cpu_vendor_id: "Производитель процессора",
            custom_cpu_freq: "Тактовая частота процессора",
            custom_cpu_core_cnt: "Количество ядер процессора"
          })
          custom_data[node].update({
            custom_cpu_vendor_id: {node => {
              custom_cpu_vendor: "Производитель процессора"
            }}
          })
        end
        if params[node][:acc_model_obj_id].present? or params[node][:custom_acc_from_node].present? or params[node][:custom_acc_model].present?
          data[node].update({
            acc_cnt: "Количество ускорителей на одном узле"
          })
        end
        if params[node][:custom_acc_model].present?
          data[node].update({
            custom_acc_type_id: "Тип ускорителя",
            custom_acc_vendor_id: "Производитель ускорителя",
            custom_acc_core_cnt: "Количество ядер/мультипроцессоров/мультипроцессорных блоков"
          })
          custom_data[node].update({
            custom_acc_type_id: {node => {
              custom_acc_type: "Тип ускорителя",
            }},
            custom_acc_vendor_id: {node => {
              custom_acc_vendor_id: "Производитель ускорителя"
            }}
          })
        end
        if params[node][:acc_only].to_i == 0
          data[node].update({
            cpu_cnt: "Количество процессоров на одном узле",
          })
          if not params[node][:custom_cpu_from_node].present?
            data[node][:cpu_model_obj_id] = "Модель процессора"
            custom_data[node].update({
              cpu_model_obj_id: {node => {
                custom_cpu_model: "Модель процессора"
              }}
            })
          end
          if not params[node][:cpu_model_obj_id].present? and not params[node][:custom_cpu_from_node].present? and params[node].has_key? :custom_cpu_model
            data[node].update({
              custom_cpu_vendor_id: "Производитель процессора",
              custom_cpu_model: "Наименование модели процессора",
              custom_cpu_freq: "Тактовая частота процессора",
              custom_cpu_core_cnt: "Количество ядер процессора"
            })
            custom_data[node].update({
              custom_cpu_vendor_id: {node => {
                custom_cpu_vendor: "Производитель процессора"
              }}
            })
          end
        else
          data[node].update({
            acc_cnt: "Количество ускорителей на одном узле",
          })
          if not params[node][:custom_acc_from_node].present?
            data[node][:acc_model_obj_id] = "Модель ускорителя"
            custom_data[node].update({
              acc_model_obj_id: {node => {
                custom_acc_model: "Модель ускорителя"
              }}
            })
          end
          if not params[node][:acc_model_obj_id].present? and not params[node][:custom_acc_from_node].present? and params[node].has_key? :custom_acc_model
            data[node].update({
              custom_acc_type_id: "Тип ускорителя",
              custom_acc_vendor_id: "Производитель ускорителя",
              custom_acc_model: "Наименование модели ускорителя",
              custom_acc_core_cnt: "Количество ядер/мультипроцессоров/мультипроцессорных блоков"
            })
            custom_data[node].update({
              custom_acc_type_id: {node => {
                custom_acc_type: "Тип ускорителя",
              }},
              custom_acc_vendor_id: {node => {
                custom_acc_vendor_id: "Производитель ускорителя"
              }}
            })
          end
        end
      end
    end
    data.keys.each do |k|
      if not params.has_key? k
        next
      end
      if data[k].is_a? Hash
        data[k].keys.each do |k2|
          if not params.fetch(k, {}).fetch(k2, nil).present?
            cd = custom_data.fetch(k, {}).fetch(k2, {})
            check_param(data[k][k2], cd, data_errs)
          end
        end
      else
        if not params.fetch(k, nil).present?
          cd = custom_data.fetch(k, {})
          check_param(data[k], cd, data_errs)
        end
      end
    end
    if data_errs.empty?
      return nil
    else
      return "Не заполнены необходимые поля: " + data_errs.join(", ")
    end
  end

  def get_short_descr(machine)
    descr = ""
    if machine.name.present?
      descr += machine.name + ", "
    end
    vendor = Top50Vendor.find(machine.vendor_ids.first)
    if vendor.present?
      descr += vendor.name + ", "
    end
    org_id = machine.org_id
    parent_rel = Top50Relation.find_by(sec_obj_id: org_id, type_id: get_rel_contain_id)
    if parent_rel.present?
      org_id = parent_rel.prim_obj_id
    end
    org = Top50Organization.find(org_id)
    if org.present?
      descr += org.name
    end
    descr += " ("
    nod_cnt = Top50Relation.where(prim_obj_id: machine.id, type_id: get_rel_contain_id).sum(:sec_obj_qty)
    if nod_cnt > 0
      descr += "узлов: " + nod_cnt.to_s
    end
    rmax_benchid = Top50Benchmark.where(name_eng: "Linpack").first.id
    rmax = Top50BenchmarkResult.where(machine_id: machine.id, benchmark_id: rmax_benchid, is_valid: 1).order(result: :desc).first
    if rmax.present?
      sc = rmax.top50_benchmark.top50_measure_unit.top50_measure_scales.where("scale < ?", rmax.result).order(scale: :desc).first
      if not sc.present?
        sc = rmax.top50_benchmark.top50_measure_unit.top50_measure_scales.order(:scale).first
      end
      if nod_cnt > 0
        descr += ", " 
      end
      descr += "Rmax: " + (rmax.result / sc.scale).to_s + " " + sc.name
    end
    descr += ", ID: " + machine.id.to_s + ")"
    return descr
  end

  def app_form_new_fail(err_msg)
    flash[:error] = err_msg
    redirect_to top50_machines_app_form_new_url
    return
  end

  def app_form_new
  end

  def app_form_new_post
    flash.delete(:error)
    if not params.has_key? :app_type or not params[:app_type].present?
      app_form_new_fail("Не выбран тип заявки")
      return
    end
    if params[:app_type] == "upgrade" 
      redirect_to top50_machines_app_form_upgrade_url
      return
    else
      redirect_to top50_machines_app_form_step1_url
      return
    end
  end

  def app_form_upgrade_fail(err_msg)
    flash[:error] = err_msg
    app_form_upgrade
    render :app_form_upgrade
    return
  end

  def app_form_upgrade
    @cur_data = params
    ed_num_attrid = Top50Attribute.where(name_eng: "Edition number").first.id
    ed_date_attrid = Top50Attribute.where(name_eng: "Edition date").first.id
    @top50_slists = get_top50_lists.select("top50_benchmarks.id, 'Редакция №' || encode(an.value, 'escape') || ' (' || encode(ad.value, 'escape') || ')' as descr").
      joins("join top50_attribute_val_dbvals an on an.obj_id = top50_benchmarks.id").
      joins("join top50_attribute_val_dbvals ad on ad.obj_id = top50_benchmarks.id").
      where("an.attr_id = ? and ad.attr_id = ?", ed_num_attrid, ed_date_attrid).
      order("cast(encode(an.value, 'escape') as int) desc")
    if get_cur(:list_id).present?
      @top50_machines = []
      top50_machines_pre = Top50BenchmarkResult.select("top50_machines.*, top50_benchmark_results.result").
      joins("join top50_machines on top50_machines.id = top50_benchmark_results.machine_id").
      where("top50_benchmark_results.benchmark_id = ?", get_cur(:list_id))
      top50_machines_pre.each do |machine|
        descr = machine.result.to_i.to_s + ": " + get_short_descr(machine)
        @top50_machines.append([descr, machine.id])
      end
    end
  end

  def app_form_upgrade_post
    flash.delete(:error)
    case params[:commit]
    when "Получить список систем для выбранной редакции"
      if not params[:list_id].present?
        app_form_upgrade_fail("Не указана редакция рейтинга, в которой присутствовала система!")
        return
      end
      app_form_upgrade
      @focus_fields = {[:form, :machine_id] => true}
      render :app_form_upgrade
    when "Далее"
      if not params[:machine_id].present?
        app_form_upgrade_fail("Не указана вычислительная система, по которой обновляются данные")
        return
      end
      app_form_step1

      top50_machine = Top50Machine.find(params[:machine_id])
      @step1_data = ActionController::Parameters.new({
        sym: :step1_data,
        prev_machine_id: params[:machine_id],
        vendor_id: top50_machine.vendor_ids.first,
        vendor_ids: top50_machine.vendor_ids.drop(1).uniq,
        name: top50_machine.name,
        name_eng: top50_machine.name_eng,
        installation_date: top50_machine.installation_date.year,
        website: top50_machine.website,
        type_id: top50_machine.type_id
      })
      parent_rel = Top50Relation.find_by(sec_obj_id: top50_machine.org_id, type_id: get_rel_contain_id)
      if parent_rel.present?
        org_id = parent_rel.prim_obj_id
        @step1_data[:suborg_id] = top50_machine.org_id
      else
        org_id = top50_machine.org_id
      end
      @step1_data[:org_id] = org_id

      @step2_data = ActionController::Parameters.new({
        sym: :step2_data
      })
      comp_node_id = Top50ObjectType.where(name_eng: 'Compute node').first.id
      gpu_typeid = Top50ObjectType.where(name_eng: "GPU").first.id
      cop_typeid = Top50ObjectType.where(name_eng: "Coprocessor").first.id
      cpu_typeid = Top50ObjectType.where(name_eng: 'CPU').first.id
      acc_typeid = Top50ObjectType.where(name_eng: "Accelerator").first.id
      acc_all_typeids = Top50ObjectType.where(parent_id: acc_typeid).pluck(:id)
      ram_size_attrid = Top50Attribute.where(name_eng: "RAM size (GB)").first.id

      i = 0
      m_rels = Top50Relation.where(is_valid: 1, prim_obj_id: top50_machine.id, type_id: get_rel_contain_id)
      m_rels.each do |rel|
        node = Top50Object.find(rel.sec_obj_id)
        if not (node.type_id == comp_node_id and node.is_valid == 1)
          next
        end
        i += 1
        node_key = format("top50_node_%d", i)
        @step2_data[node_key] = {
          fake_id: i,
          node_cnt: rel.sec_obj_qty
        }
        ram = Top50AttributeValDbval.find_by(attr_id: ram_size_attrid, obj_id: node.id, is_valid: 1)
        if ram.present?
          @step2_data[node_key][:ram_size] = ram.value
        end
        n_rels = Top50Relation.where(is_valid: 1, prim_obj_id: node.id, type_id: get_rel_contain_id)
        n_rels.each do |rel1|
          comp = Top50Object.find(rel1.sec_obj_id)
          if comp.type_id == cpu_typeid and comp.is_valid == 1
            @step2_data[node_key][:cpu_cnt] = rel1.sec_obj_qty
            @step2_data[node_key][:cpu_model_obj_id] = comp.id
          elsif acc_all_typeids.include? comp.type_id and comp.is_valid == 1
            @step2_data[node_key][:acc_cnt] = rel1.sec_obj_qty
            @step2_data[node_key][:acc_model_obj_id] = comp.id
          end
        end
      end
      @step2_data[:last_fake_id] = i

      @step3_data = ActionController::Parameters.new({
        sym: :step3_data,
        app_area: {},
        nets: {}
      })
      app_area_attrid = Top50Attribute.where(name_eng: "Application area").first.id
      comm_net_attrid = Top50Attribute.where(name_eng: "Communication network").first.id
      comm_fam_attrid = Top50Attribute.where(name_eng: "Communication network family").first.id
      tplg_attrid = Top50Attribute.where(name_eng: "Topology").first.id
      tran_net_attrid = Top50Attribute.where(name_eng: "Transport network").first.id
      serv_net_attrid = Top50Attribute.where(name_eng: "Service network").first.id
      app_area = Top50AttributeValDict.find_by(attr_id: app_area_attrid, obj_id: top50_machine.id, is_valid: 1)
      if app_area.present?
        @step3_data[:app_area][:app_dict_elem_id] = app_area.dict_elem_id
      end
      net_attrs = {
        comm_net_dict_elem_id: comm_net_attrid,
        comm_net_family_id: comm_fam_attrid,
        tplg_dict_elem_id: tplg_attrid,
        tran_net_dict_elem_id: tran_net_attrid,
        serv_net_dict_elem_id: serv_net_attrid
      }
      net_attrs.each do |k, v|
        attr_val = Top50AttributeValDict.find_by(attr_id: v, obj_id: top50_machine.id, is_valid: 1)
        if attr_val.present?
          @step3_data[:nets][k] = attr_val.dict_elem_id
        end
      end

      @step4_data = ActionController::Parameters.new({
        sym: :step4_data,
        top50_perf: {}
      })
      rmax_benchid = Top50Benchmark.where(name_eng: "Linpack").first.id
      nmax_attrid = Top50Attribute.where(name_eng: "Linpack Nmax").first.id
      linpack_out_attrid = Top50Attribute.where(name_eng: "Linpack Output").first.id
      rpeak_attrid = Top50Attribute.where(name_eng: "Rpeak (MFlop/s)").first.id
      rpeak = Top50AttributeValDbval.find_by(attr_id: rpeak_attrid, obj_id: top50_machine.id, is_valid: 1)
      if rpeak.present?
        @step4_data[:top50_perf][:rpeak] = rpeak.value.to_f / 1000000.0
      end
      rmax = Top50BenchmarkResult.find_by(benchmark_id: rmax_benchid, machine_id: top50_machine.id, is_valid: 1)
      if rmax.present?
        @step4_data[:top50_perf][:rmax] = rmax.result / 1000000.0
        nmax = Top50AttributeValDbval.find_by(attr_id: nmax_attrid, obj_id: rmax.id, is_valid: 1)
        if nmax.present?
          @step4_data[:top50_perf][:msize] = nmax.value.to_i
        end
        linpack_out = Top50AttributeValDbval.find_by(attr_id: linpack_out_attrid, obj_id: rmax.id, is_valid: 1)
        if linpack_out.present?
          @step4_data[:top50_perf][:linpack_output] = linpack_out.value
        end
      end
      @cur_data = @step1_data

      render :app_form_step1
      return
    when "Назад"
      redirect_to top50_machines_app_form_new_url
      return
    end
  end

  def app_form_step1
    @rel_contain_id = get_rel_contain_id
    fetch_all_data_from_params
    @cur_data = @step1_data
  end
 
  def app_form_step1_presave
    flash.delete(:error)
    case params[:commit]
    when "Добавить производителя"
      app_form_step1
      @cur_data[:custom_vendor] = {}
      @cur_data[:vendor_id] = nil
      @focus_fields = {[:custom_vendor, :name] => true}
      render :app_form_step1
    when "Добавить ещё одного участвующего производителя"
      app_form_step1
      @cur_data[format("add_vendor_%d", @cur_data[:add_vendors_cnt].to_i + 1)] = {}
      @focus_fields = {[format("add_vendor_%d", @cur_data[:add_vendors_cnt].to_i + 1), :name] => true}
      render :app_form_step1
    when "Добавить новый тип"
      app_form_step1
      @cur_data[:custom_type] = {}
      @cur_data[:type_id] = nil
      @focus_fields = {[:custom_type, :name] => true}
      render :app_form_step1
    when "Добавить организацию"
      app_form_step1
      @cur_data[:custom_org] = {}
      @cur_data[:org_id] = nil
      @focus_fields = {[:custom_org, :name] => true}
      render :app_form_step1
    when "Добавить новое подразделение"
      app_form_step1
      @cur_data[:custom_suborg] = {}
      @cur_data[:suborg_id] = nil
      @focus_fields = {[:custom_suborg, :name] => true}
      render :app_form_step1
    when "Указать подразделение"
      if not params[:org_id].present? and not params.has_key? :custom_org
        @focus_fields = {[:form, :org_id] => true}
        app_form_step1_fail("Для указания подазделения необходимо сначала указать организацию")
        return
      end
      app_form_step1
      @cur_data[:suborg_id] = nil
      @focus_fields = {[:form, :suborg_id] => true}
      if params.has_key? :custom_org and not params[:org_id].present?
        @cur_data[:custom_suborg] = {}
        @focus_fields = {[:custom_suborg, :name] => true}
      end
      render :app_form_step1
    when "Далее"
      x = validate_req_params(:step1)
      if x.present?
        app_form_step1_fail(x)
        return
      end
      if params[:cond_accepted].to_i != 1
        app_form_step1_fail("Для подачи заявки необходимо подтвердить согласие на обработку данных.")
        return
      end
      app_form_step2
      render :app_form_step2
    else
      app_form_step1
      @cur_data.reject! {|k,v| v.is_a? Hash and v.fetch(:commit, "").starts_with? "Убрать"}
      render :app_form_step1
    end
    return
  end

  def app_form_step1_fail(err_msg)
    flash[:error] = err_msg
    app_form_step1
    render :app_form_step1
    return
  end

  def app_form_step2
    @rel_contain_id = get_rel_contain_id
    @cpu_typeid = Top50ObjectType.where(name_eng: 'CPU').first.id
    @cpu_dict_id = Top50Dictionary.where(name_eng: 'CPU model').first.id
    @cpu_vendor_dict_id = Top50Dictionary.where(name_eng: 'CPU Vendor').first.id
    @cpu_gen_dict_id = Top50Dictionary.where(name_eng: 'CPU generations').first.id
    @cpu_family_dict_id = Top50Dictionary.where(name_eng: 'CPU families').first.id
    @gpu_dict_id = Top50Dictionary.where(name_eng: 'GPU model').first.id
    @gpu_vendor_dict_id = Top50Dictionary.where(name_eng: 'GPU Vendor').first.id
    @cop_dict_id = Top50Dictionary.where(name_eng: 'Coprocessor model').first.id
    @cop_vendor_dict_id = Top50Dictionary.where(name_eng: 'Coprocessor Vendor').first.id
    @acc_dict_id = [@gpu_dict_id, @cop_dict_id]
    @acc_vendor_dict_id = [@cop_vendor_dict_id, @gpu_vendor_dict_id]
    @acc_typeid = Top50ObjectType.where(name_eng: "Accelerator").first.id
    @acc_all_typeids = Top50ObjectType.where(parent_id: @acc_typeid).pluck(:id)

    cpu_model_attrid = Top50Attribute.where(name_eng: "CPU model").first.id
    cpu_vendor_attrid = Top50Attribute.where(name_eng: "CPU Vendor").first.id
    @cpu_objects = Top50Object.select("top50_objects.id, dv.name || ' ' || dm.name as name").
      joins("join top50_attribute_val_dicts av on av.obj_id = top50_objects.id and av.attr_id = #{cpu_vendor_attrid}").
      joins("join top50_dictionary_elems dv on dv.id = av.dict_elem_id and dv.dict_id = #{@cpu_vendor_dict_id}").
      joins("join top50_attribute_val_dicts am on am.obj_id = top50_objects.id and am.attr_id = #{cpu_model_attrid}").
      joins("join top50_dictionary_elems dm on dm.id = am.dict_elem_id and dm.dict_id = #{@cpu_dict_id}").
      where("top50_objects.type_id = ? and top50_objects.is_valid = 1", @cpu_typeid).
      order("dv.name, dm.name")
  
    gpu_model_attrid = Top50Attribute.where(name_eng: "GPU model").first.id
    gpu_vendor_attrid = Top50Attribute.where(name_eng: "GPU Vendor").first.id
    cop_model_attrid = Top50Attribute.where(name_eng: "Coprocessor model").first.id
    cop_vendor_attrid = Top50Attribute.where(name_eng: "Coprocessor Vendor").first.id
    @acc_objects = Top50Object.select("top50_objects.id, dv.name || ' ' || dm.name as name").
      joins("join top50_attribute_val_dicts av on av.obj_id = top50_objects.id").
      joins("join top50_dictionary_elems dv on dv.id = av.dict_elem_id").
      joins("join top50_attribute_val_dicts am on am.obj_id = top50_objects.id").
      joins("join top50_dictionary_elems dm on dm.id = am.dict_elem_id").
      where("top50_objects.type_id in (?) and top50_objects.is_valid = 1 and av.attr_id in (?) and dv.dict_id in (?) and am.attr_id in (?) and dm.dict_id in (?)",
        @acc_all_typeids, [gpu_vendor_attrid, cop_vendor_attrid], @acc_vendor_dict_id, [gpu_model_attrid, cop_model_attrid], @acc_dict_id).
      order("dv.name, dm.name")

    fetch_all_data_from_params
    @cur_data = @step2_data
    @custom_cpus = []
    @custom_accs = []
    @cur_data.select {|k,v| k.starts_with? 'top50_node_'}.values.each do |node|
      if node[:custom_cpu_model].present?
        if node[:custom_cpu_vendor_id].present?
          cpu_ven_str = Top50DictionaryElem.find(node[:custom_cpu_vendor_id].to_i).name
        else
          cpu_ven_str = node[:custom_cpu_vendor]
        end
        @custom_cpus.append([format("%s %s", cpu_ven_str, node[:custom_cpu_model]), node[:fake_id]])
      end
      if node[:custom_acc_model].present?
        if node[:custom_acc_vendor_id].present?
          acc_ven_str = Top50DictionaryElem.find(node[:custom_acc_vendor_id].to_i).name
        else
          acc_ven_str = node[:custom_acc_vendor]
        end
        @custom_accs.append([format("%s %s", acc_ven_str, node[:custom_acc_model]), node[:fake_id]])
      end
    end
  end
 
  def app_form_step2_presave
    flash.delete(:error)
    case params[:commit]
    when "Добавить группу узлов"
      app_form_step2
      fake_id = @cur_data[:last_fake_id].to_i + 1
      @cur_data[format("top50_node_%d", fake_id)] = {
        fake_id: fake_id
      }
      @cur_data[:last_fake_id] = fake_id
      @focus_fields = {[format("top50_node_%d", fake_id), :node_cnt] => true}
      render :app_form_step2
    when "Назад"
      app_form_step1
      render :app_form_step1
    when "Далее"
      x = validate_req_params(:step2)
      if x.present?
        app_form_step2_fail(x)
        return
      end
      app_form_step3
      render :app_form_step3
    else
      params.reject! {|k,v| v.is_a? Hash and v.fetch(:commit, "").starts_with? "Удалить"}
      app_form_step2
      @cur_data.select {|k,v| k.starts_with? 'top50_node_'}.keys.sort.each do |node|
        case @cur_data[node].fetch(:commit, nil)
        when "Добавить модель процессора"
          @cur_data[node][:custom_cpu_model] = nil
          @cur_data[node][:cpu_model_obj_id] = nil
          @focus_fields = {[node, :custom_cpu_model] => true}
        when "Добавить модель ускорителя"
          @cur_data[node][:custom_acc_model] = nil
          @cur_data[node][:acc_model_obj_id] = nil
          @focus_fields = {[node, :custom_acc_model] => true}
        end
      end
      render :app_form_step2
    end
    return
  end
 
  def app_form_step2_fail(err_msg)
    flash[:error] = err_msg
    app_form_step2
    render :app_form_step2
    return
  end

  def app_form_step3
    @app_dict_id = Top50Dictionary.where(name_eng: 'Application areas').first.id
    @net_dict_id = Top50Dictionary.where(name_eng: 'Computer networks').first.id
    @net_fam_dict_id = Top50Dictionary.where(name_eng: 'Net families').first.id
    @tplg_dict_id = Top50Dictionary.where(name_eng: 'Topologies').first.id
    @rel_contain_id = get_rel_contain_id
    fetch_all_data_from_params
    @cur_data = @step3_data
  end

  def app_form_step3_presave
    flash.delete(:error)
    case params[:commit]
    when "Назад"
      app_form_step2
      render :app_form_step2
    when "Далее"
      x = validate_req_params(:step3)
      if x.present?
        app_form_step3_fail(x)
        return
      end
      app_form_step4
      render :app_form_step4
    end
    return
  end

  def app_form_step3_fail(err_msg)
    flash[:error] = err_msg
    app_form_step3
    render :app_form_step3
    return
  end

  def app_form_step4
    fetch_all_data_from_params
    @cur_data = @step4_data
  end

  def app_form_step4_presave
    flash.delete(:error)
    case params[:commit]
    when "Назад"
      app_form_step3
      render :app_form_step3
    when "Далее"
      x = validate_req_params(:step4)
      if x.present?
        app_form_step4_fail(x)
        return
      end
      app_form_confirm
      render :app_form_confirm
    end
    return
  end

  def app_form_step4_fail(err_msg)
    flash[:error] = err_msg
    app_form_step4
    render :app_form_step4
    return
  end

  def app_form_confirm
    core_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of cores"))
    @core_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(core_qty_attrs)
    microcore_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of micro cores"))
    @microcore_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(microcore_qty_attrs)
    cpu_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "CPU model"))
    @cpu_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cpu_model_attrs)
    cpu_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "CPU Vendor"))
    @cpu_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cpu_vendor_attrs)
    comp_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where("name_eng LIKE '% model'"))
    @comp_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(comp_model_attrs)
    comp_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where("name_eng LIKE '% Vendor'"))
    @comp_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(comp_vendor_attrs)

    fetch_all_data_from_params
    if @step1_data[:prev_machine_id].present?
      @prev_machine_descr = get_short_descr(Top50Machine.find(@step1_data[:prev_machine_id].to_i))
    end
  end
 
  def app_form_confirm_post
    flash.delete(:error)
    case params[:commit]
    when "Назад"
      app_form_step4
      render :app_form_step4
    when "Перейти в начало"
      app_form_step1
      render :app_form_step1
    when "Отправить заявку"
      x = validate_req_params(:confirm)
      if x.present?
        app_form_confirm_fail(x)
        return
      end
      app_form_finish 
      render :app_form_finish
    end
    return
  end
 
 def app_form_confirm_fail(err_msg)
    flash[:error] = err_msg
    app_form_confirm
    render :app_form_confirm
    return
  end

  def app_form_finish
    fetch_all_data_from_params
    if @step1_data[:vendor_id].present?
      vendor_id = @step1_data[:vendor_id].to_i
    else
      vendor_id = Top50Vendor.create(
        name: @step1_data[:custom_vendor][:name],
        name_eng: @step1_data[:custom_vendor][:name_eng],
        website: @step1_data[:custom_vendor][:website],
        is_valid: 2
      ).id
    end
    vendor_ids = @step1_data[:vendor_ids].clone
    vendor_ids.delete("")
    vendor_ids.collect! {|x| x.to_i}
    vendor_ids = ([vendor_id] + vendor_ids).uniq
    (@step1_data.select {|k,v| k.starts_with? 'add_vendor_'}).keys.each do |vendor|
      vendor_ids.append(Top50Vendor.create(
        name: @step1_data[vendor][:name],
        name_eng: @step1_data[vendor][:name_eng],
        website: @step1_data[vendor][:website],
        is_valid: 2
      ).id)
    end
    if @step1_data[:org_id].present?
      first_org_id = @step1_data[:org_id].to_i
    else
      city = Top50City.find_by(name: @step1_data[:custom_org][:city])
      if city.present?
        city_id = city.id
      else
        city_id = Top50City.create(
          name: @step1_data[:custom_org][:city],
          is_valid: 2,
          comment: @step1_data[:custom_org][:country]
        ).id
      end
      first_org_id = Top50Organization.create(
        name: @step1_data[:custom_org][:name],
        name_eng: @step1_data[:custom_org][:name_eng],
        city_id: city_id,
        is_valid: 2
      ).id
    end
    if @step1_data[:suborg_id].present?
      org_id = @step1_data[:suborg_id].to_i
    elsif @step1_data[:custom_suborg].present?
      city = Top50City.find_by(name: @step1_data[:custom_suborg][:city])
      if city.present?
        city_id = city.id
      else
         city_id = Top50City.create(
          name: @step1_data[:custom_suborg][:city],
          is_valid: 2,
          comment: @step1_data[:custom_suborg][:country]
        ).id
      end
      org_id = Top50Organization.create(
        name: @step1_data[:custom_suborg][:name],
        name_eng: @step1_data[:custom_suborg][:name_eng],
        city_id: city_id,
        is_valid: 2
      ).id
      Top50Relation.create(
        prim_obj_id: first_org_id,
        sec_obj_id: org_id,
        type_id: get_rel_contain_id,
        is_valid: 2,
        comment: format("%d is parent org for %d", first_org_id, org_id)
      )
    else
      org_id = first_org_id
    end
    if @step1_data[:type_id].present?
      type_id = @step1_data[:type_id].to_i
    else
      type_id = Top50MachineType.create(
        name: @step1_data[:custom_type][:name],
        name_eng: @step1_data[:custom_type][:name_eng],
        is_valid: 2
      ).id
    end
    contact_id = Top50Contact.create(
      name: @step1_data[:contact][:name],
      surname: @step1_data[:contact][:surname],
      patronymic: @step1_data[:contact][:patronymic],
      phone: @step1_data[:contact][:phone],
      email: @step1_data[:contact][:email],
      extra_info: @step1_data[:contact][:extra_info],
      is_valid: 2
    ).id
    @top50_machine = Top50Machine.create(
      name: @step1_data[:name],
      name_eng: @step1_data[:name_eng],
      website: @step1_data[:website],
      installation_date: Date.parse(format("%s-01-01", @step1_data[:installation_date])),
      vendor_id: vendor_id,
      vendor_ids: vendor_ids,
      org_id: org_id,
      type_id: type_id,
      contact_id: contact_id,
      is_valid: 2,
      comment: format('{"step2": "%s", "step3": "%s", "step4": "%s"}', @step2_data[:comment], @step4_data[:comment], @step4_data[:comment])
    )
    if @step1_data[:prev_machine_id].present?
      Top50Relation.create(
        prim_obj_id: @step1_data[:prev_machine_id].to_i,
        sec_obj_id: @top50_machine.id,
        type_id: get_rel_precede_id,
        is_valid: 2,
        comment: format("%s is precedent machine for %d", @step1_data[:prev_machine_id], @top50_machine.id)
      )
    end

    gpu_typeid = Top50ObjectType.where(name_eng: "GPU").first.id
    cop_typeid = Top50ObjectType.where(name_eng: "Coprocessor").first.id
    comp_node_id = Top50ObjectType.where(name_eng: 'Compute node').first.id
    cpu_typeid = Top50ObjectType.where(name_eng: 'CPU').first.id
    acc_parent_type_id = Top50ObjectType.where(name_eng: 'Accelerator').first.id

    cpu_dict_id = Top50Dictionary.where(name_eng: 'CPU model').first.id
    cpu_vendor_dict_id = Top50Dictionary.where(name_eng: 'CPU Vendor').first.id
    cpu_gen_dict_id = Top50Dictionary.where(name_eng: 'CPU generations').first.id
    cpu_fam_dict_id = Top50Dictionary.where(name_eng: 'CPU families').first.id
    gpu_dict_id = Top50Dictionary.where(name_eng: 'GPU model').first.id
    gpu_vendor_dict_id = Top50Dictionary.where(name_eng: 'GPU Vendor').first.id
    cop_dict_id = Top50Dictionary.where(name_eng: 'Coprocessor model').first.id
    cop_vendor_dict_id = Top50Dictionary.where(name_eng: 'Coprocessor Vendor').first.id
    acc_dict_id = Top50Dictionary.where(name_eng: 'Accelerator model').first.id
    acc_vendor_dict_id = Top50Dictionary.where(name_eng: 'Accelerator Vendor').first.id

    freq_attrid = Top50Attribute.where(name_eng: "Clock frequency (MHz)").first.id
    cores_attrid = Top50Attribute.where(name_eng: "Number of cores").first.id
    microcores_attrid = Top50Attribute.where(name_eng: "Number of micro cores").first.id
    cpu_model_attrid = Top50Attribute.where(name_eng: "CPU model").first.id
    cpu_vendor_attrid = Top50Attribute.where(name_eng: "CPU Vendor").first.id
    cpu_fam_attrid = Top50Attribute.where(name_eng: "CPU family").first.id
    cpu_gen_attrid = Top50Attribute.where(name_eng: "CPU generation").first.id
    gpu_model_attrid = Top50Attribute.where(name_eng: "GPU model").first.id
    gpu_vendor_attrid = Top50Attribute.where(name_eng: "GPU Vendor").first.id
    cop_model_attrid = Top50Attribute.where(name_eng: "Coprocessor model").first.id
    cop_vendor_attrid = Top50Attribute.where(name_eng: "Coprocessor Vendor").first.id
    acc_model_attrid = Top50Attribute.where(name_eng: "Accelerator model").first.id
    acc_vendor_attrid = Top50Attribute.where(name_eng: "Accelerator Vendor").first.id
    ram_size_attrid = Top50Attribute.where(name_eng: "RAM size (GB)").first.id
    
    custom_cpu_objects = {}
    custom_acc_objects = {}
    @step2_data.select {|k,v| k.starts_with? 'top50_node_'}.values.each do |top50_node|
      node_id = Top50Object.create(
        type_id: comp_node_id,
        is_valid: 2,
        comment: format("belongs to machine %d", @top50_machine.id)
      ).id
      Top50Relation.create(
        prim_obj_id: @top50_machine.id,
        sec_obj_id: node_id,
        type_id: get_rel_contain_id,
        sec_obj_qty: top50_node[:node_cnt],
        is_valid: 2
      )
      if top50_node[:cpu_model_obj_id].present? or top50_node[:custom_cpu_from_node].present? or top50_node[:custom_cpu_model].present?
        if top50_node[:cpu_model_obj_id].present?
          cpu_obj_id = top50_node[:cpu_model_obj_id].to_i
        else
          if top50_node[:custom_cpu_from_node].present?
            cpu_src_node = @step2_data[format('top50_node_%s', top50_node[:custom_cpu_from_node])]
          else
            cpu_src_node = top50_node
          end
          if custom_cpu_objects.has_key? cpu_src_node[:fake_id]
            cpu_obj_id = custom_cpu_objects[cpu_src_node[:fake_id]]
          else
            cpu_obj_id = Top50Object.create(
              type_id: cpu_typeid,
              is_valid: 2,
              comment: format("new CPU for machine %d", @top50_machine.id)
            ).id
            custom_cpu_objects[cpu_src_node[:fake_id]] = cpu_obj_id
            if cpu_src_node[:custom_cpu_vendor_id].present? or cpu_src_node[:custom_cpu_vendor].present?
              if cpu_src_node[:custom_cpu_vendor_id].present?
                cpu_vendor_dict_elem_id = cpu_src_node[:custom_cpu_vendor_id].to_i
              else
                cpu_vendor_dict_elem_id = Top50DictionaryElem.create(
                  name: cpu_src_node[:custom_cpu_vendor], 
                  dict_id: cpu_vendor_dict_id,
                  is_valid: 2,
                  comment: format("new cpu vendor for machine %d", @top50_machine.id)
                ).id
              end
              Top50AttributeValDict.create(
                attr_id: cpu_vendor_attrid,
                obj_id: cpu_obj_id,
                dict_elem_id: cpu_vendor_dict_elem_id,
                is_valid: 2,
                comment: format("cpu vendor for machine %d", @top50_machine.id)
              )
            end
            if cpu_src_node[:custom_cpu_gen_id].present? or cpu_src_node[:custom_cpu_gen].present?
              if cpu_src_node[:custom_cpu_gen_id].present?
                cpu_gen_dict_elem_id = cpu_src_node[:custom_cpu_gen_id].to_i
              else
                cpu_gen_dict_elem_id = Top50DictionaryElem.create(
                  name: cpu_src_node[:custom_cpu_gen], 
                  dict_id: cpu_gen_dict_id,
                  is_valid: 2,
                  comment: format("new cpu generation for machine %d", @top50_machine.id)
                ).id
              end
              Top50AttributeValDict.create(
                attr_id: cpu_gen_attrid,
                obj_id: cpu_obj_id,
                dict_elem_id: cpu_gen_dict_elem_id,
                is_valid: 2,
                comment: format("cpu generation for machine %d", @top50_machine.id)
              )
            end
            if cpu_src_node[:custom_cpu_family_id].present? or cpu_src_node[:custom_cpu_family].present?
              if cpu_src_node[:custom_cpu_family_id].present?
                cpu_fam_dict_elem_id = cpu_src_node[:custom_cpu_family_id].to_i
              else
                cpu_fam_dict_elem_id = Top50DictionaryElem.create(
                  name: cpu_src_node[:custom_cpu_family],
                  dict_id: cpu_fam_dict_id,
                  is_valid: 2,
                  comment: format("new cpu family for machine %d", @top50_machine.id)
                ).id
              end
              Top50AttributeValDict.create(
                attr_id: cpu_fam_attrid,
                obj_id: cpu_obj_id,
                dict_elem_id: cpu_fam_dict_elem_id,
                is_valid: 2,
                comment: format("cpu family for machine %d", @top50_machine.id)
              )
            end
            cpu_model_dict_elem_id = Top50DictionaryElem.create(
              name: cpu_src_node[:custom_cpu_model],
              dict_id: cpu_dict_id,
              is_valid: 2,
              comment: format("new cpu model for machine %d", @top50_machine.id)
            ).id
            Top50AttributeValDict.create(
              attr_id: cpu_model_attrid,
              obj_id: cpu_obj_id,
              dict_elem_id: cpu_model_dict_elem_id,
              is_valid: 2,
              comment: format("cpu model for machine %d", @top50_machine.id)
            )
            if cpu_src_node[:custom_cpu_freq].present?
              Top50AttributeValDbval.create(
                attr_id: freq_attrid,
                obj_id: cpu_obj_id,
                value: cpu_src_node[:custom_cpu_freq],
                is_valid: 2,
                comment: format("cpu frequency for machine %d", @top50_machine.id)
              )
            end
            if cpu_src_node[:custom_cpu_core_cnt].present?
              Top50AttributeValDbval.create(
                attr_id: cores_attrid,
                obj_id: cpu_obj_id,
                value: cpu_src_node[:custom_cpu_core_cnt],
                is_valid: 2,
                comment: format("cpu cores for machine %d", @top50_machine.id)
              )
            end
          end
        end
        Top50Relation.create(
          prim_obj_id: node_id,
          sec_obj_id: cpu_obj_id,
          type_id: get_rel_contain_id,
          sec_obj_qty: top50_node[:cpu_cnt],
          is_valid: 2
        )
      end
      if top50_node[:acc_model_obj_id].present? or top50_node[:custom_acc_from_node].present? or top50_node[:custom_acc_model].present?
        if top50_node[:acc_model_obj_id].present?
          acc_obj_id = top50_node[:acc_model_obj_id].to_i
        else
          if top50_node[:custom_acc_from_node].present?
            acc_src_node = @step2_data[format('top50_node_%s', top50_node[:custom_acc_from_node])]
          else
            acc_src_node = top50_node
          end
          if custom_acc_objects.has_key? acc_src_node[:fake_id]
            acc_obj_id = custom_acc_objects[acc_src_node[:fake_id]]
          else
            if acc_src_node[:custom_acc_type_id].present?
              type_id = acc_src_node[:custom_acc_type_id].to_i
            else
              type_id = Top50ObjectType.create(
                name: acc_src_node[:custom_acc_type],
                parent_id: acc_parent_type_id,
                is_valid: 2
              ).id
            end
            acc_obj_id = Top50Object.create(
              type_id: type_id,
              is_valid: 2,
              comment: format("new acc for machine %d", @top50_machine.id)
            ).id
            custom_acc_objects[acc_src_node[:fake_id]] = acc_obj_id
            case type_id
            when gpu_typeid
              cur_acc_dict_id = gpu_dict_id
              cur_acc_vendor_dict_id = gpu_vendor_dict_id
              cur_acc_model_attrid = gpu_model_attrid
              cur_acc_vendor_attrid = gpu_vendor_attrid
            when cop_typeid
              cur_acc_dict_id = cop_dict_id
              cur_acc_vendor_dict_id = cop_vendor_dict_id
              cur_acc_model_attrid = cop_model_attrid
              cur_acc_vendor_attrid = cop_vendor_attrid
            else
              cur_acc_dict_id = acc_dict_id
              cur_acc_vendor_dict_id = acc_vendor_dict_id
              cur_acc_model_attrid = acc_model_attrid
              cur_acc_vendor_attrid = acc_vendor_attrid
            end
            if acc_src_node[:custom_acc_vendor_id].present? or acc_src_node[:custom_acc_vendor].present?
              if acc_src_node[:custom_acc_vendor_id].present?
                acc_vendor_dict_elem_id = acc_src_node[:custom_acc_vendor_id].to_i
              else
                acc_vendor_dict_elem_id = Top50DictionaryElem.create(
                  name: acc_src_node[:custom_acc_vendor],
                  dict_id: cur_acc_vendor_dict_id,
                  is_valid: 2,
                  comment: format("new acc vendor for machine %d", @top50_machine.id)
                ).id
              end
              Top50AttributeValDict.create(
                attr_id: cur_acc_vendor_attrid,
                obj_id: acc_obj_id,
                dict_elem_id: acc_vendor_dict_elem_id,
                is_valid: 2,
                comment: format("acc vendor for machine %d", @top50_machine.id)
              )
            end
            acc_model_dict_elem_id = Top50DictionaryElem.create(
              name: acc_src_node[:custom_acc_model],
              dict_id: cur_acc_dict_id,
              is_valid: 2,
              comment: format("new acc model for machine %d", @top50_machine.id)
            ).id
            Top50AttributeValDict.create(
              attr_id: cur_acc_model_attrid,
              obj_id: acc_obj_id,
              dict_elem_id: acc_model_dict_elem_id,
              is_valid: 2,
              comment: format("acc model for machine %d", @top50_machine.id)
            )
            if acc_src_node[:custom_acc_freq].present?
              Top50AttributeValDbval.create(
                attr_id: freq_attrid,
                obj_id: acc_obj_id,
                value: acc_src_node[:custom_acc_freq],
                is_valid: 2,
                comment: format("acc frequency for machine %d", @top50_machine.id)
              )
            end
            if acc_src_node[:custom_acc_core_cnt].present?
              Top50AttributeValDbval.create(
                attr_id: cores_attrid,
                obj_id: acc_obj_id,
                value: acc_src_node[:custom_acc_core_cnt],
                is_valid: 2,
                comment: format("acc cores for machine %d", @top50_machine.id)
              )
            end
            if acc_src_node[:custom_acc_microcore_cnt].present?
              Top50AttributeValDbval.create(
                attr_id: microcores_attrid,
                obj_id: acc_obj_id,
                value: acc_src_node[:custom_acc_microcore_cnt],
                is_valid: 2,
                comment: format("acc micro cores for machine %d", @top50_machine.id)
              )
            end
          end
        end
        Top50Relation.create(
          prim_obj_id: node_id,
          sec_obj_id: acc_obj_id,
          type_id: get_rel_contain_id,
          sec_obj_qty: top50_node[:acc_cnt],
          is_valid: 2
        )
      end
      Top50AttributeValDbval.create(
        attr_id: ram_size_attrid,
        obj_id: node_id,
        value: top50_node[:ram_size],
        is_valid: 2,
        comment: format("RAM size for machine %d", @top50_machine.id)
      )
    end
    app_dict_id = Top50Dictionary.where(name_eng: 'Application areas').first.id
    net_dict_id = Top50Dictionary.where(name_eng: 'Computer networks').first.id
    net_fam_dict_id = Top50Dictionary.where(name_eng: 'Net families').first.id
    tplg_dict_id = Top50Dictionary.where(name_eng: 'Topologies').first.id
    app_area_attrid = Top50Attribute.where(name_eng: "Application area").first.id
    comm_net_attrid = Top50Attribute.where(name_eng: "Communication network").first.id
    comm_fam_attrid = Top50Attribute.where(name_eng: "Communication network family").first.id
    serv_net_attrid = Top50Attribute.where(name_eng: "Service network").first.id
    tran_net_attrid = Top50Attribute.where(name_eng: "Transport network").first.id
    tplg_attrid = Top50Attribute.where(name_eng: "Topology").first.id
    if @step3_data[:app_area][:app_dict_elem_id].present?
      app_dict_elem_id = @step3_data[:app_area][:app_dict_elem_id].to_i
    else
      app_dict_elem_id = Top50DictionaryElem.create(
        name: @step3_data[:app_area][:custom_app],
        dict_id: app_dict_id,
        is_valid: 2,
        comment: format("new app area for machine %s", @top50_machine.id)
      ).id
    end
    Top50AttributeValDict.create(
      attr_id: app_area_attrid,
      obj_id: @top50_machine.id,
      dict_elem_id: app_dict_elem_id,
      is_valid: 2,
      comment: format("app area for machine %d", @top50_machine.id)
    )
    added_nets = {}
    if @step3_data[:nets][:comm_net_dict_elem_id].present?
      comm_net_dict_elem_id = @step3_data[:nets][:comm_net_dict_elem_id].to_i
    else
      comm_net_dict_elem_id = Top50DictionaryElem.create(
        name: @step3_data[:nets][:custom_comm_net],
        dict_id: net_dict_id,
        is_valid: 2,
        comment: format("new comm net for machine %d", @top50_machine.id)
      ).id
      added_nets[@step3_data[:nets][:custom_comm_net]] = comm_net_dict_elem_id
    end
    Top50AttributeValDict.create(
      attr_id: comm_net_attrid,
      obj_id: @top50_machine.id,
      dict_elem_id: comm_net_dict_elem_id,
      is_valid: 2,
      comment: format("comm net for machine %d", @top50_machine.id)
    )
    if @step3_data[:nets][:tran_net_dict_elem_id].present? or @step3_data[:nets][:custom_tran_net].present?
      if @step3_data[:nets][:tran_net_dict_elem_id].present?
        tran_net_dict_elem_id = @step3_data[:nets][:tran_net_dict_elem_id].to_i
      elsif added_nets.has_key? @step3_data[:nets][:custom_tran_net]
        tran_net_dict_elem_id = added_nets[@step3_data[:nets][:custom_tran_net]]
      else
        tran_net_dict_elem_id = Top50DictionaryElem.create(
          name: @step3_data[:nets][:custom_tran_net],
          dict_id: net_dict_id,
          is_valid: 2,
          comment: format("new tran net for machine %d", @top50_machine.id)
        ).id
        added_nets[@step3_data[:nets][:custom_tran_net]] = tran_net_dict_elem_id
      end
      Top50AttributeValDict.create(
        attr_id: tran_net_attrid,
        obj_id: @top50_machine.id,
        dict_elem_id: tran_net_dict_elem_id,
        is_valid: 2,
        comment: format("tran net for machine %d", @top50_machine.id)
      )
    end
    if @step3_data[:nets][:serv_net_dict_elem_id].present? or @step3_data[:nets][:custom_serv_net].present?
      if @step3_data[:nets][:serv_net_dict_elem_id].present?
        serv_net_dict_elem_id = @step3_data[:nets][:serv_net_dict_elem_id].to_i
      elsif added_nets.has_key? @step3_data[:nets][:custom_serv_net]
        serv_net_dict_elem_id = added_nets[@step3_data[:nets][:custom_serv_net]]
      else
        serv_net_dict_elem_id = Top50DictionaryElem.create(
          name: @step3_data[:nets][:custom_serv_net],
          dict_id: net_dict_id,
          is_valid: 2,
          comment: format("new serv net for machine %d", @top50_machine.id)
        ).id
        added_nets[@step3_data[:nets][:custom_serv_net]] = serv_net_dict_elem_id
      end
      Top50AttributeValDict.create(
        attr_id: serv_net_attrid,
        obj_id: @top50_machine.id,
        dict_elem_id: serv_net_dict_elem_id,
        is_valid: 2,
        comment: format("serv net for machine %d", @top50_machine.id)
      )
    end
    if @step3_data[:nets][:tplg_dict_elem_id].present?
      tplg_dict_elem_id = @step3_data[:nets][:tplg_dict_elem_id].to_i
    else
      tplg_dict_elem_id = Top50DictionaryElem.create(
        name: @step3_data[:nets][:custom_tplg],
        dict_id: tplg_dict_id,
        is_valid: 2,
        comment: format("new topology for machine %d", @top50_machine.id)
      ).id
    end
    Top50AttributeValDict.create(
      attr_id: tplg_attrid,
      obj_id: @top50_machine.id,
      dict_elem_id: tplg_dict_elem_id,
      is_valid: 2,
      comment: format("topology for machine %d", @top50_machine.id)
    )
    if @step3_data[:nets][:comm_net_family_id].present? or @step3_data[:nets][:custom_comm_family].present?
      if @step3_data[:nets][:comm_net_family_id].present?
        comm_fam_dict_elem_id = @step3_data[:nets][:comm_net_family_id].to_i
      else
        comm_fam_dict_elem_id = Top50DictionaryElem.create(
          name: @step3_data[:nets][:custom_comm_family],
          dict_id: net_fam_dict_id,
          is_valid: 2,
          comment: format("new comm net family for machine %d", @top50_machine.id)
        ).id
      end
      Top50AttributeValDict.create(
        attr_id: comm_fam_attrid,
        obj_id: @top50_machine.id,
        dict_elem_id: comm_fam_dict_elem_id,
        is_valid: 2,
        comment: format("comm net family for machine %d", @top50_machine.id)
      )
    end
    rmax_benchid = Top50Benchmark.where(name_eng: "Linpack").first.id
    bres_id = Top50BenchmarkResult.create(
      benchmark_id: rmax_benchid,
      machine_id: @top50_machine.id,
      result: @step4_data[:top50_perf][:rmax].to_f * 1000000,
      is_valid: 2,
      comment: format("rmax result for machine %d", @top50_machine.id)
    ).id
    nmax_attrid = Top50Attribute.where(name_eng: "Linpack Nmax").first.id
    Top50AttributeValDbval.create(
      attr_id: nmax_attrid,
      obj_id: bres_id,
      value: @step4_data[:top50_perf][:msize],
      is_valid: 2,
      comment: format("Nmax for machine %d", @top50_machine.id)
    )
    if @step4_data[:top50_perf][:linpack_output].present?
      linpack_out_attrid = Top50Attribute.where(name_eng: "Linpack Output").first.id
      Top50AttributeValDbval.create(
        attr_id: linpack_out_attrid,
        obj_id: bres_id,
        value: @step4_data[:top50_perf][:linpack_output],
        is_valid: 2,
        comment: format("Linpack output for machine %d", @top50_machine.id)
      )
    end
    rpeak_attrid = Top50Attribute.where(name_eng: "Rpeak (MFlop/s)").first.id
    Top50AttributeValDbval.create(
      attr_id: rpeak_attrid,
      obj_id: @top50_machine.id,
      value: (@step4_data[:top50_perf][:rpeak].to_f * 1000000).to_s,
      is_valid: 2,
      comment: format("Rpeak for machine %d", @top50_machine.id)
    )
    Top50Mailer.app_confirm_email({step1_data: @step1_data, step2_data: @step2_data, step3_data: @step3_data, step4_data: @step4_data, id: @top50_machine.id}).deliver!
  end

  
  private
  
  def top50machine_params
    params.require(:top50_machine).permit(:name, :name_eng, :website, :type_id, :org_id, :vendor_id, :vendor_ids, :contact_id, :installation_date, :start_date, :end_date, :is_valid, :comment)
  end

  def top50_benchmark_result_params
    params.require(:top50_benchmark_result).permit(:benchmark_id, :result, :is_valid)
  end
  
  def top50_node_params
    params.require(:top50_relation).permit(:top50_node => [:sec_obj_qty, :is_valid], :top50_cpu => [:model_dict_elem_id, :sec_obj_qty, :is_valid], :top50_acc => [:model_dict_elem_id, :sec_obj_qty, :is_valid], :top50_ram => [:ram_size, :is_valid])
  end
end

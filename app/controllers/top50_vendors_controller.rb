class Top50VendorsController < Top50BaseController
  def index
    @top50_vendors = Top50Vendor.all
  end

  def show
    @top50_vendor = Top50Vendor.find(params[:id])
  end
  
  def stats
	
	name_eng_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Name(eng)"))
	top50_bunches_all = Top50Object.all.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Bunch of benchmarks"))
	top50_bunch_attr_name = (Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(name_eng_attrs)).joins(:top50_object).merge(top50_bunches_all).find_by(value: "Top50 position")
	@top50_lists = Top50Benchmark.all.joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}")

	@top50_slists = @top50_lists.select("top50_benchmarks.*, encode(top50_attribute_val_dbvals.value, 'escape') as num").joins("join top50_attribute_val_dbvals on top50_attribute_val_dbvals.obj_id = top50_benchmarks.id").joins("join top50_attributes on top50_attributes.id = top50_attribute_val_dbvals.attr_id and top50_attributes.name_eng = 'Edition number'").order("cast(encode(top50_attribute_val_dbvals.value, 'escape') as int) desc")
	
	all_res = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(@top50_lists)

	#@top50_machines = Top50Machine.all.where("#{@vendor.id} = ANY(vendor_ids)").joins(:top50_benchmark_results).merge(@rated_pos.order(result: :asc))
	#@top50_machines = Top50Machine.all.joins(:top50_benchmark_results).merge(all_res)
	@top50_vendors = Top50Vendor.all.select("coalesce(v2.id, top50_vendors.id) as id, coalesce(v2.name, top50_vendors.name) as name, count(1) cnt").joins("left join (select prim_obj_id, sec_obj_id from top50_relations join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Precedes') pr_v on top50_vendors.id = pr_v.prim_obj_id").joins("left join top50_vendors v2 on v2.id = pr_v.sec_obj_id").joins("join top50_machines on top50_vendors.id = ANY(top50_machines.vendor_ids)").joins("join top50_benchmark_results on top50_benchmark_results.machine_id = top50_machines.id").joins("join top50_benchmarks on top50_benchmarks.id = top50_benchmark_results.benchmark_id").joins("join top50_relations on top50_benchmarks.id = top50_relations.sec_obj_id").joins("join top50_relation_types on top50_relation_types.id = top50_relations.type_id and top50_relation_types.name_eng = 'Contains'").where("top50_relations.prim_obj_id = #{top50_bunch_attr_name.obj_id}").group("coalesce(v2.id, top50_vendors.id), coalesce(v2.name, top50_vendors.name)").order("cnt desc").having("count(1) > #{params[:thres]}")
	
	prec_relation = Top50Relation.all.joins(:top50_relation_type).merge(Top50RelationType.where(name_eng: "Precedes"))
    @prec_vendors = prec_relation.joins(:top50_object).merge(Top50Object.joins(:top50_object_type).merge(Top50ObjectType.where(name_eng: "Vendor")))
	
 	list_num_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition number"))
    @num_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_num_attrs)
	list_date_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Edition date"))
    @date_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(list_date_attrs)
    
	#@bench = Top50Benchmark.find(edition_id)	
	#@rated_pos = Top50BenchmarkResult.all.joins(:top50_benchmark).merge(Top50Benchmark.where(id: edition_id))
    #ed_num = (@num_vals.find_by(obj_id: edition_id).value).to_i
	
  end

 
  def new
    @top50_vendor = Top50Vendor.new
  end

  def create
    @top50_vendor = Top50Vendor.new(top50vendor_params)
    if @top50_vendor.save
      redirect_to :back
    else
      render :new
    end
  end

  def edit
    @top50_vendor = Top50Vendor.find(params[:id])
  end

  def update
    @top50_vendor = Top50Vendor.find(params[:id])
    @top50_vendor.update_attributes(top50vendor_params)
    redirect_to :top50_vendors
  end

  def destroy
    @top50_vendor = Top50Vendor.find(params[:id])
    @top50_vendor.destroy
    redirect_to :top50_vendors
  end

  def default
    Top50Vendor.default!
  end

  private

  def top50vendor_params
    params.require(:top50_vendor).permit(:name, :name_eng, :website, :is_valid)
  end
end

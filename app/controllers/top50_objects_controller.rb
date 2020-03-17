class Top50ObjectsController < Top50BaseController
  skip_before_filter :require_login, only: [:show_info]
  skip_before_filter :require_admin_rights, only: [:show_info]
  def index
    @top50_objects = Top50Object.all
  end
  
  def index_type
    #top50_obj_gr = Top50Object.all.group(:type_id).count
    #@top50_object_types = Top50ObjectType.all.joins(top50_obj_gr)
    @top50_object_types = Top50ObjectType.select("top50_object_types.id, top50_object_types.name, top50_object_types.name_eng, count(1) as cnt").joins(:top50_objects).group("top50_object_types.id, top50_object_types.name, top50_object_types.name_eng")
  end
  
  def objects_of_type
    # if ['CPU', 'GPU', 'Coprocessor', 'Acceletator'] include? Top50ObjectType.find(params[:tid]).name_eng
    model_attrid = Top50Attribute.where(name_eng: "Accelerator model").first
    case Top50ObjectType.find(params[:tid]).name_eng
    when 'CPU'
      model_attrid = Top50Attribute.where(name_eng: "CPU model").first
    when 'GPU'
      model_attrid = Top50Attribute.where(name_eng: "GPU model").first
    when 'Coprocessor'
      model_attrid = Top50Attribute.where(name_eng: "Coprocessor model").first
    end
    @top50_objects = Top50Object.select("top50_objects.*, de.name").
      joins("left join top50_attribute_val_dicts avd on avd.obj_id = top50_objects.id").
      joins("left join top50_dictionary_elems de on de.id = avd.dict_elem_id").
      where("top50_objects.type_id = ? and (avd.attr_id = ? or avd.attr_id is null)", params[:tid], model_attrid).
      order("de.name, top50_objects.id") 
    cpu_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "CPU model"))
    @cpu_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cpu_model_attrs)
    gpu_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "GPU model"))
    @gpu_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(gpu_model_attrs)
  end

  def attribute_vals
    @top50_object = Top50Object.find(params[:id])
  end

  def show
    @top50_object = Top50Object.find(params[:id])
  end
  
  def show_info
    @top50_object = Top50Object.find(params[:id])
  end 

  def new_attribute_val_dbval
    @top50_object = Top50Object.find(params[:id])
    @top50_attr_val = Top50AttributeValDbval.new
  end

  def create_attribute_val_dbval
    @top50_object = Top50Object.find(params[:id])
    @top50_attr_val = @top50_object.top50_attribute_val_dbvals.build(top50_attr_val_dbval_params)
    if @top50_attr_val.save
      redirect_to @top50_object
    else
      render :new_attribute_val_dbval
    end
  end

  def edit_attribute_val_dbval
    @top50_attr_val = Top50AttributeValDbval.find(params[:avid])
    @top50_object = Top50Object.find(params[:id])
  end

  def save_attribute_val_dbval
    @top50_attr_val = Top50AttributeValDbval.find(params[:avid])
    @top50_object = Top50Object.find(params[:id])
    @top50_attr_val.update(top50_attr_val_dbval_params)
    @top50_attr_val.save!
    redirect_to @top50_object
  end

  def destroy_attribute_val_dbval
    @top50_attr_val = Top50AttributeValDbval.find(params[:avid])
    @top50_object = Top50Object.find(params[:id])
    @top50_attr_val.destroy!
    redirect_to @top50_object
  end

  def relations
    @top50_object = Top50Object.find(params[:id])
  end

  def new_relation
    @top50_object = Top50Object.find(params[:id])
    @top50_nested_object = Top50Object.new
    @top50_relation = Top50Relation.new
  end

  def create_relation
    @top50_object = Top50Object.find(params[:id])
    @top50_relation = @top50_object.top50_relations.build(top50_nested_object_params[:top50_relation])
    if top50_nested_object_params[:top50_object][:id].present?
      @top50_nested_object = Top50Object.find(top50_nested_object_params[:top50_object][:id])
    else
      @top50_nested_object = Top50Object.new(top50_nested_object_params[:top50_object])
      @top50_nested_object.save!
    end
    @top50_relation.sec_obj_id = @top50_nested_object.id
    if @top50_relation.save
      redirect_to @top50_object
    else
      render :new_relation
    end
  end

  def new_attribute_val_dict_set_attr
    attr = Top50AttributeDict.find(params[:attr_id])
    redirect_to proc { new_top50_object_top50_attribute_val_dict_step2_path(params[:id], attr.id) }
    return
  end

  def new_attribute_val_dict_step2
    @top50_object = Top50Object.find(params[:id])
    attr = Top50AttributeDict.find(params[:attrid])
    @attr_id = attr.id
    @dict_id = attr.dict_id
  end

  def edit_attribute_val_dict
    @top50_attr_val = Top50AttributeValDict.find(params[:avid])
    attr = Top50AttributeDict.find(@top50_attr_val.attr_id)
    @attr_id = attr.id
    @dict_id = attr.dict_id
    @top50_object = Top50Object.find(params[:id])
  end

  def save_attribute_val_dict
    @top50_attr_val = Top50AttributeValDict.find(params[:avid])
    @top50_object = Top50Object.find(params[:id])
    @top50_attr_val.update(top50_attr_val_dict_params)
    @top50_attr_val.save!
    redirect_to @top50_object
  end

  def destroy_attribute_val_dict
    @top50_attr_val = Top50AttributeValDict.find(params[:avid])
    @top50_object = Top50Object.find(params[:id])
    @top50_attr_val.destroy!
    redirect_to @top50_object
  end

  def new_attribute_val_dict
    @top50_object = Top50Object.find(params[:id])
    @top50_attr_val = Top50AttributeValDict.new
  end

  def create_attribute_val_dict
    @top50_object = Top50Object.find(params[:id])
    @top50_attr_val = @top50_object.top50_attribute_val_dicts.build(top50_attr_val_dict_params)
    if @top50_attr_val.save
      redirect_to @top50_object
    else
      redirect_to proc { new_top50_object_top50_attribute_val_dict_step2_path(@top50_object, @top50_attr_val.attr_id) }
    end
  end

  def show
    @top50_object = Top50Object.find(params[:id])
  end
 
  def new
    @top50_object = Top50Object.new
  end

  def create
    @top50_object = Top50Object.new(top50_object_params)
    if @top50_object.save
      redirect_to @top50_object
    else
      render :new
    end
  end

  def edit
    @top50_object = Top50Object.find(params[:id])
  end

  def update
    @top50_object = Top50Object.find(params[:id])
    @top50_object.update_attributes(top50_object_params)
    redirect_to @top50_object
  end

  def destroy
    @top50_object = Top50Object.find(params[:id])
    @top50_object.destroy
    redirect_to :top50_objects
  end

  def default
    Top50Object.default!
  end

  private

  def top50_object_params
    params.require(:top50_object).permit(:type_id, :is_valid)
  end

  def top50_attr_val_dbval_params
    params.require(:top50_attribute_val_dbval).permit(:attr_id, :value, :is_valid)
  end

  def top50_attr_val_dict_params
    params.require(:top50_attribute_val_dict).permit(:attr_id, :dict_elem_id, :is_valid)
  end

  def top50_nested_object_params
    params.require(:top50_relation).permit(:top50_relation => [:type_id, :sec_obj_qty, :is_valid], :top50_object => [:id, :type_id, :is_valid])
  end

end

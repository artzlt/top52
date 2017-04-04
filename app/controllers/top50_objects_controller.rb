class Top50ObjectsController < ApplicationController

  def index
    @top50_objects = Top50Object.all
  end
  
  def index_type
    #top50_obj_gr = Top50Object.all.group(:type_id).count
    #@top50_object_types = Top50ObjectType.all.joins(top50_obj_gr)
    @top50_object_types = Top50ObjectType.select("top50_object_types.id, top50_object_types.name, top50_object_types.name_eng, count(1) as cnt").joins(:top50_objects).group("top50_object_types.id, top50_object_types.name, top50_object_types.name_eng")
  end
  
  def objects_of_type
    @top50_objects = Top50Object.where(type_id: params[:tid])
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

  def nested_objects
    @top50_object = Top50Object.find(params[:id])
  end

  def new_nested_object
    @top50_object = Top50Object.find(params[:id])
    @top50_nested_object = Top50Object.new
    @top50_relation = Top50Relation.new
  end

  def create_nested_object
    @top50_object = Top50Object.find(params[:id])
    @top50_relation = @top50_object.top50_relations.build(top50_nested_object_params[:top50_relation])
    @top50_nested_object = Top50Object.new(top50_nested_object_params[:top50_object])
    @top50_nested_object.save!
    @top50_relation.sec_obj_id = @top50_nested_object.id
    if @top50_relation.save
      redirect_to @top50_object
    else
      render :new_nested_obj
    end
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
      render :new_attribute_val_dict
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
    redirect_to :top50_objects
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
    params.require(:top50_object).permit(:type_id)
  end

  def top50_attr_val_dbval_params
    params.require(:top50_attribute_val_dbval).permit(:attr_id, :value)
  end

  def top50_attr_val_dict_params
    params.require(:top50_attribute_val_dict).permit(:attr_id, :dict_elem_id)
  end

  def top50_nested_object_params
    params.require(:top50_relation).permit(:top50_relation => [:type_id, :sec_obj_qty], :top50_object => [:type_id])
  end

end

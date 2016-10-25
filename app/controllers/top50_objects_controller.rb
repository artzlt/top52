class Top50ObjectsController < ApplicationController

  def index
    @top50_objects = Top50Object.all
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
      redirect_to :top50_objects
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

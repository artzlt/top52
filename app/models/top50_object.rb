class Top50Object < ActiveRecord::Base

  #attr_accessor :id, :type_id, :is_valid, :comment
  belongs_to :top50_object_type, foreign_key: "type_id"
  has_one :top50_machine, foreign_key: "id"
  has_one :top50_contact, foreign_key: "id"
  has_one :top50_organization, foreign_key: "id"
  has_one :top50_vendor, foreign_key: "id"
  has_many :top50_attribute_val_dbvals, foreign_key: "obj_id"
  has_many :top50_attribute_val_dicts, foreign_key: "obj_id"
  has_many :top50_relations, foreign_key: "prim_obj_id"
  #has_many :top50_relations, foreign_key: "sec_obj_id"
  
  before_destroy do
    Top50AttributeValDbval.where(obj_id: self.id).destroy_all
    Top50AttributeValDict.where(obj_id: self.id).destroy_all
    Top50Relation.where(prim_obj_id: self.id).destroy_all
    Top50Relation.where(sec_obj_id: self.id).destroy_all
  end

  def get_rel_contain_id
    return Top50RelationType.where(name_eng: 'Contains').first.id
  end

  def get_rel_preced_id
    return Top50RelationType.where(name_eng: 'Precedes').first.id
  end

  def type
    return self.top50_object_type.name
  end

  def type_eng
    return self.top50_object_type.name_eng
  end

  def confirm
    if self.is_valid != 1
      self.is_valid = 1
      self.save
    end
    self.top50_attribute_val_dbvals.update_all(is_valid: 1)
    self.top50_attribute_val_dicts.update_all(is_valid: 1)
    rel_preced_id = get_rel_preced_id
    Top50Relation.
      where(sec_obj_id: self.id, type_id: rel_preced_id).
      update_all(is_valid: 1)

    rel_contain_id = get_rel_contain_id
    self.top50_relations.where(type_id: rel_contain_id).each do |r|
      r.update(is_valid: 1)
      r.top50_object.confirm
    end
  end

  def all_attr_dicts
    result = {}
    self.top50_attribute_val_dicts.each do |avd|
      result[avd.top50_attribute_dict.top50_attribute.name_eng] = avd.top50_dictionary_elem.name
    end
    return result
  end

  def all_attr_dbvals
    result = {}
    self.top50_attribute_val_dbvals.each do |avd|
      result[avd.top50_attribute_dbval.top50_attribute.name_eng] = avd.get_value
    end
    return result
  end

  def all_attrs
    return self.all_attr_dicts.merge(self.all_attr_dbvals)
  end

  def attr_dbval_value_by_id(attr_id)
    r = self.top50_attribute_val_dbvals.find_by(attr_id: attr_id)
    if r.present?
      return r.get_value
    end
  end

  def attr_dict_value_by_id(attr_id)
    r = self.top50_attribute_val_dicts.find_by(attr_id: attr_id)
    if r.present?
      return r.top50_dictionary_elem.name
    end
  end

  def attr_value_by_attr(attr)
    case attr.attr_type
    when 1
      return self.attr_dbval_value_by_id(attr.id)
    when 2
      return attr_dict_value_by_id(attr.id)
    end
  end

  def attr_value_by_id(attr_id)
    attr = Top50Attribute.find_by(id: attr_id)
    if attr.present?
      return self.attr_value_by_attr(attr)
    end
  end

  def attr_value(attr_name)
    attr = Top50Attribute.find_by(name_eng: attr_name)
    if attr.present?
      return self.attr_value_by_attr(attr)
    end
  end

  def set_attrs(data, dry_run=true, force=false)
    puts "dry_run is " + dry_run.to_s
    obj_id = self.id
    data.each do |attr_name, value|
        a = Top50Attribute.find_by(name_eng: attr_name)
        if a.present?
            if a.attr_type == 1
                avd = Top50AttributeValDbval.find_by(attr_id: a.id, obj_id: obj_id)
                if avd.present?
                    puts "Already has value for dbval attr #{attr_name}: #{avd.value}. Want to set : #{value}"
                    if not dry_run and force
                        avd.value = value.to_s
                        avd.comment = "Edited by set_attrs"
                        puts "Re-set #{value} for dbval attr #{attr_name} (attr_id = #{a.id}) and obj_id = #{obj_id}"
                        avd.save!
                    end
                else
                    if not dry_run
                        Top50AttributeValDbval.create(attr_id: a.id, obj_id: obj_id, value: value.to_s, is_valid: 1, comment: "Created by set_attrs")
                        puts "Set #{value} for dbval attr #{attr_name} (attr_id = #{a.id}) and obj_id = #{obj_id}"
                    end
                end
            elsif a.attr_type == 2
                d = Top50AttributeDict.find(a.id).top50_dictionary
                dict_elem = Top50DictionaryElem.find_by(dict_id: d.id, name_eng: value.to_s)
                if not dict_elem.present?
                    puts "Dict elem with name #{value} not found in #{d.name_eng} (dict_id = #{d.id})"
                    if not dry_run and force
                        dict_elem = Top50DictionaryElem.create(dict_id: d.id, name: value.to_s, name_eng: value.to_s, is_valid: 1, comment: "Created by set_attrs")
                    end
                end
                avd = Top50AttributeValDict.find_by(attr_id: a.id, obj_id: obj_id)
                if avd.present?
                    puts "Already has value for dict attr #{attr_name}: #{avd.top50_dictionary_elem.name_eng}. Want to set : #{value}"
                    if not dry_run and force
                        avd.dict_elem.id = dict_elem.id
                        avd.comment = "Edited by set_attrs"
                        puts "Re-set #{dict_elem.name_eng} (dict_elem_id = #{dict_elem.id}) for dict attr #{attr_name} (attr_id = #{a.id}) and obj_id = #{obj_id}"
                        avd.save!
                    end
                else
                    if not dry_run
                        Top50AttributeValDict.create(attr_id: a.id, obj_id: obj_id, dict_elem_id: dict_elem.id, is_valid: 1, comment: "Created by set_attrs")
                        puts "Set #{dict_elem.name_eng} (dict_elem_id = #{dict_elem.id}) for dict attr #{attr_name} (attr_id = #{a.id}) and obj_id = #{obj_id}"
                    end
                end
            end
        else
            puts "Attribute " + attr_name + " not found!"
            if not dry_run
                break
            end
        end
    end
  end

  def print_type_or_abort(obj_id, hint)
    obj = Top50Object.find(obj_id)
    if obj.present?
        puts "#{hint} object (#{obj.id}) type is #{obj.top50_object_type.name_eng}"
    else
        raise "not found object with id = #{obj_id}"
    end
  end   

  def create_son(options, dry_run=true, force=false)
    puts "dry_run is " + dry_run.to_s
    parent_obj_id = self.id
    obj_id = options[:obj_id]
    if obj_id.present?
        print_type_or_abort(obj_id, 'Son')
    else
        type = Top50ObjectType.find_by(name_eng: options[:type])
        if type.present?
            puts "Will create son object with type #{type.name_eng}"
            if not dry_run
                obj_id = Top50Object.create(type_id: type.id, is_valid: 1, comment: 'Created by create_son').id
                puts "Created object with type #{type.name_eng} (#{obj_id})"
            end
        else
            raise "Type #{options[:type]} not found!"
        end
    end

    rel = Top50Relation.find_by(prim_obj_id: parent_obj_id, sec_obj_id: obj_id, type_id: 1)
    if rel.present?
        puts "Relation between #{rel.prim_obj_id} and #{rel.sec_obj_id} already exists, count = #{rel.sec_obj_qty}"
        if not dry_run and force
            rel.sec_obj_qty = options[:count]
            rel.comment = 'Edited by create_son'
            puts "Set count = #{rel.sec_obj_qty} for relation between #{rel.prim_obj_id} and #{rel.sec_obj_id}"
            rel.save!
        end
    else
        if not dry_run
            rel = Top50Relation.create(prim_obj_id: parent_obj_id, sec_obj_id: obj_id, type_id: 1, sec_obj_qty: options[:count], is_valid: 1, comment: 'Created by create_son')
            puts "Created relation between #{rel.prim_obj_id} and #{rel.sec_obj_id} with count = #{rel.sec_obj_qty} and id = #{rel.id}"
        end
    end
    return Top50Object.find_by(id: obj_id)
  end
end

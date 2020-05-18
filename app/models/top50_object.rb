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

end

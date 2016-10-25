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
end

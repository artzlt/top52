class Top50AttributeValDict < ActiveRecord::Base
  belongs_to :top50_attribute_dict, foreign_key: "attr_id"
  belongs_to :top50_object, foreign_key: "obj_id"
  belongs_to :top50_dictionary_elem, foreign_key: "dict_elem_id"
  validates_uniqueness_of :attr_id, scope: :obj_id
end

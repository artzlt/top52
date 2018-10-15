class Top50AttributeValDict < ActiveRecord::Base
  belongs_to :top50_attribute_dict, foreign_key: "attr_id"
  belongs_to :top50_object, foreign_key: "obj_id"
  belongs_to :top50_dictionary_elem, foreign_key: "dict_elem_id"
end

class Top50AttributeValDbval < ActiveRecord::Base
  belongs_to :top50_attribute_dbval, foreign_key: "attr_id"
  belongs_to :top50_object, foreign_key: "obj_id"
end

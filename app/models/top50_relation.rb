class Top50Relation < ActiveRecord::Base
#  belongs_to :top50_object, foreign_key: "prim_obj_id"
  belongs_to :top50_object, foreign_key: "sec_obj_id"
  belongs_to :top50_relation_type, foreign_key: "type_id"
end

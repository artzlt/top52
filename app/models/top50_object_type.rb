class Top50ObjectType < ActiveRecord::Base
  has_many :top50_objects, foreign_key: "type_id"
  belongs_to :top50_object_type, foreign_key: "parent_id"
  has_many :top50_object_types, foreign_key: "parent_id"
end

class Top50ObjectType < ActiveRecord::Base
  has_many :top50_object, foreign_key: "type_id"
end

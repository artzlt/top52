class Top50RelationType < ActiveRecord::Base
  has_many :top50_relations, foreign_key: "type_id"
end

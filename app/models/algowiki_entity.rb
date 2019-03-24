class AlgowikiEntity < ActiveRecord::Base
    belongs_to :algowiki_entity_type, foreign_key: "type_id"
    has_many :algo_attribute_values_dbs, foreign_key: "obj_id"
    has_many :algo_attribute_value_dicts, foreign_key: "obj_id"
    has_many :algowiki_relations, foreign_key: "prim_id"
    has_many :algowiki_secondary_relations, class_name: "AlgowikiRelation", foreign_key: "sec_id"
end

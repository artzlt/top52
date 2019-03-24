class AlgowikiRelation < ActiveRecord::Base
    belongs_to :algowiki_entity, foreign_key: "sec_id"
    belongs_to :algowiki_primary_entity, class_name: "AlgowikiEntity", foreign_key: "prim_id"
    belongs_to :algowiki_relation_type, foreign_key: "type_id"
end

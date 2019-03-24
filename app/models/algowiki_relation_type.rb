class AlgowikiRelationType < ActiveRecord::Base
    has_many :algowiki_relations, foreign_key: "type_id"
end

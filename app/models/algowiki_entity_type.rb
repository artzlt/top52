class AlgowikiEntityType < ActiveRecord::Base
    self.primary_key = "id"
    belongs_to :algowiki_entity_type, foreign_key: "parent_id"
    has_many :algowiki_entities, foreign_key: "type_id"
end

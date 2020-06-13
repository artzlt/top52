class AlgowikiEntity < ActiveRecord::Base
    belongs_to :algowiki_entity_type, foreign_key: "type_id"
    has_many :algo_attribute_values_dbs, foreign_key: "obj_id"
    has_many :algo_attribute_value_dicts, foreign_key: "obj_id"
    has_many :algowiki_relations, foreign_key: "prim_id"
    has_many :algowiki_secondary_relations, class_name: "AlgowikiRelation", foreign_key: "sec_id"
    has_many :implementations, foreign_key: "alg_id", class_name: "AlgoImplementation"

  def get_childs
    result = []
    self.algowiki_relations.where(type_id: 1).each do |rel|
      result.append(rel.sec_id)
    end
    return result
  end

  def get_subtree
    result = [self.id]
    self.get_childs.each do |c|
      result += AlgowikiEntity.find(c).get_subtree
    end
    return result
  end

  def get_all_imps
    return AlgoImplementation.where(alg_id: self.get_subtree)
  end

  def type
    return self.algowiki_entity_type.name
  end

  def type_eng
    return self.algowiki_entity_type.name_eng
  end

end

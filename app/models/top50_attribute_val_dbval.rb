class Top50AttributeValDbval < ActiveRecord::Base
  belongs_to :top50_attribute_dbval, foreign_key: "attr_id"
  belongs_to :top50_object, foreign_key: "obj_id"
  validates_uniqueness_of :attr_id, scope: :obj_id

  def self.fetch_value(db_code, value)
    case db_code
    when 'INTEGER'
      return value.to_i
    when 'REAL'
      return value.to_f
    when 'DATE'
      return Date.parse(value)
    end
    return value
  end

  def get_value
    return Top50AttributeValDbval.fetch_value(
      self.top50_attribute_dbval.top50_attribute_datatype.db_code,
      self.value
    )
    case self.top50_attribute_dbval.top50_attribute_datatype.db_code
    when 'INTEGER'
      return self.value.to_i
    when 'REAL'
      return self.value.to_f
    when 'DATE'
      return Date.parse(self.value)
    end
    return self.value
  end
end

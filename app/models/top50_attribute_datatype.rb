class Top50AttributeDatatype < ActiveRecord::Base
  has_many :top50_attribute_dbvals, foreign_key: "datatype_id"
end

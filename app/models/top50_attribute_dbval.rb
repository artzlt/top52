class Top50AttributeDbval < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_attribute, foreign_key: "id"
  belongs_to :top50_attribute_datatype, foreign_key: "datatype_id"  
  has_many :top50_attribute_val_dbvals, foreign_key: "attr_id"  
end

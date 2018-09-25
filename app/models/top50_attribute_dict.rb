class Top50AttributeDict < ActiveRecord::Base

  self.primary_key = "id"
  belongs_to :top50_attribute, foreign_key: "id"
  belongs_to :top50_dictionary, foreign_key: "dict_id"  
  has_many :top50_attribute_val_dicts, foreign_key: "attr_id"  

  before_save do
    if self.new_record? 
      a = Top50Attribute.new
      a[:attr_type] = 2
      a[:is_valid] = 1
      a.save!
      self.id = a.id
    end
  end

  before_destroy do
    a = Top50Attribute.find(self.id)
    a.destroy!
  end

end

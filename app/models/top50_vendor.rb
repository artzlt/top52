class Top50Vendor < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"
  belongs_to :top50_country, foreign_key: "country_id"
  has_many :top50_machines, foreign_key: "vendor_id"
  validates :name, presence: true

  before_save do
    if self.new_record? 
      c_typeid = Top50ObjectType.where(name_eng: "Vendor").first.id
      obj = Top50Object.new
      obj[:type_id] = c_typeid
      obj[:is_valid] = self.is_valid
      obj[:comment] = format('New vendor (%s)', self.comment)
      obj.save!
      self.id = obj.id
    end
    if self.is_valid != self.top50_object.is_valid
      self.top50_object.update(is_valid: self.is_valid)
    end
  end

  before_destroy do
    obj = Top50Object.find(self.id)
    obj.destroy!
  end

  def machines
    return Top50Machine.where("#{self.id} = ANY(vendor_ids)")
  end

  def confirm
    if self.is_valid != 1
      self.is_valid = 1
      self.save
    end
    self.top50_object.confirm
  end

end

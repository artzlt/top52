class LaunchResult < ActiveRecord::Base
  belongs_to :top50_object, foreign_key: "id"  
  belongs_to :impl, foreign_key: "imp_id", class_name: "AlgoImplementation"
  belongs_to :top50_machine, foreign_key: "machine_id"
  belongs_to :node_group, foreign_key: "node_group_id", class_name: "Top50Object"
  
  before_save do
    if self.new_record?
      b_typeid = Top50ObjectType.where(name_eng: "Launch result").first.id
      obj = Top50Object.new
      obj[:type_id] = b_typeid
      obj[:is_valid] = self.is_valid
      obj[:comment] = format('New launch result (%s)', self.comment)
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

  def confirm
    if self.is_valid != 1
      self.is_valid = 1
      self.save
    end
    self.top50_object.confirm
  end

end

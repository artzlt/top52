class PartialLaunch < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :launch_result, foreign_key: "launch_id"
  belongs_to :comp_group, foreign_key: "comp_group_id", class_name: "Top50Object"
  belongs_to :sub_group, foreign_key: "sub_group_id", class_name: "Top50Object"

  def confirm
    if self.is_valid != 1
      self.is_valid = 1
      self.save
    end
  end

end

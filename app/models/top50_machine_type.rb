class Top50MachineType < ActiveRecord::Base
  has_many :top50_machines, foreign_key: "type_id"
  validates :name, :name_eng, presence: true
end

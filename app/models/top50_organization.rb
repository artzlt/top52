class Top50Organization < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"
  belongs_to :top50_city, foreign_key: "city_id"
  has_many :top50_machines, foreign_key: "org_id"
  validates :name, presence: true
end

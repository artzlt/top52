class Top50Vendor < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"
  belongs_to :top50_country, foreign_key: "country_id"
  has_many :top50_machines, foreign_key: "vendor_id"
  validates :name, :name_eng, presence: true
end

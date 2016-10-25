class Top50City < ActiveRecord::Base
  belongs_to :top50_region, foreign_key: "region_id"
  has_many :top50_organizations, foreign_key: "city_id"
end

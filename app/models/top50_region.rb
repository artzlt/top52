class Top50Region < ActiveRecord::Base
  belongs_to :top50_country, foreign_key: "country_id"
  has_many :top50_cities, foreign_key: "region_id"
end

class Top50Country < ActiveRecord::Base
  has_many :top50_regions, foreign_key: "country_id"
  has_many :top50_vendors, foreign_key: "country_id"
end

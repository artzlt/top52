class Top50City < ActiveRecord::Base
  belongs_to :top50_region, foreign_key: "region_id"
  has_many :top50_organizations, foreign_key: "city_id"

  def country
    if self.top50_region.present? and self.top50_region.top50_country.present?
      return self.top50_region.top50_country
    end
  end
end

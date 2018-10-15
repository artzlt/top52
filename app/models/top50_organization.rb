class Top50Organization < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"
  belongs_to :top50_city, foreign_key: "city_id"
  has_many :top50_machines, foreign_key: "org_id"
  validates :name, presence: true
  
  scope :finder, ->(q){ where("name like :q", q: "%#{q.mb_chars}%").order(:name) }
  
  def as_json(options)
    { id: id, text: name }
  end
end

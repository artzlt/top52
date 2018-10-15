class Top50Contact < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"
  has_many :top50_machines, foreign_key: "contact_id"

  validates :name, :name_eng, :surname, :surname_eng, presence: true

  def full_name
    "#{name} #{surname}"
  end
  def full_name_eng
    "#{name_eng} #{surname_eng}"
  end
end

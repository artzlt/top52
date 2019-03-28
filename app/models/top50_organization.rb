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

  before_save do
    if self.new_record? 
      c_typeid = Top50ObjectType.where(name_eng: "Organization").first.id
      obj = Top50Object.new
      obj[:type_id] = c_typeid
      obj[:is_valid] = self.is_valid.present? ? self.is_valid : 1
      obj[:comment] = format('New organization (%s)', self.comment)
      obj.save!
      self.id = obj.id
    end
  end

  before_destroy do
    obj = Top50Object.find(self.id)
    obj.destroy!
  end


end

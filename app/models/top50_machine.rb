class Top50Machine < ActiveRecord::Base

  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"
  belongs_to :top50_machine_type, foreign_key: "type_id"
  belongs_to :top50_contact, foreign_key: "contact_id"
  belongs_to :top50_organization, foreign_key: "org_id"
  belongs_to :top50_vendor, foreign_key: "vendor_ids"
  has_many :top50_benchmark_results, foreign_key: "machine_id"

  before_save do
    if self.new_record? 
      m_typeid = Top50ObjectType.where(name_eng: "Machine").first.id
      obj = Top50Object.new
      obj[:type_id] = m_typeid
      obj[:is_valid] = self.is_valid.present? ? self.is_valid : 1
      obj[:comment] = format('New machine (%s)', self.comment)
      obj.save!
      self.id = obj.id
    end
    if self.vendor_id.present?
      self.vendor_ids = ([self.vendor_id] + self.vendor_ids).uniq
    end
  end

  before_destroy do
    Top50BenchmarkResult.where(machine_id: self.id).destroy_all
    obj = Top50Object.find(self.id)
    obj.destroy!
  end

  # validates :cond, acceptance: { message: 'Для подачи заявки необходимо подтвердить согласие на обработку данных.' }
end

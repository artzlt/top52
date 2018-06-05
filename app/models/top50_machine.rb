class Top50Machine < ActiveRecord::Base

  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"
  belongs_to :top50_machine_type, foreign_key: "type_id"
  belongs_to :top50_contact, foreign_key: "contact_id"
  belongs_to :top50_organization, foreign_key: "org_id"
  belongs_to :top50_vendor, foreign_key: "vendor_ids"
  has_many :top50_benchmark_results, foreign_key: "machine_id"

  # validates :cond, acceptance: { message: 'Для подачи заявки необходимо подтвердить согласие на обработку данных.' }
end

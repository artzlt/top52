class Top50Benchmark < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"  
  belongs_to :top50_measure_unit, foreign_key: "measure_id"
  has_many :top50_benchmark_results, foreign_key: "benchmark_id", dependent: :destroy

  before_save do
    if self.new_record? 
      b_typeid = Top50ObjectType.where(name_eng: "Benchmark").first.id
      obj = Top50Object.new
      obj[:type_id] = b_typeid
      obj[:is_valid] = 1
      obj[:comment] = format('New benchmark (%s)', self.comment)
      obj.save!
      self.id = obj.id
    end
  end

  before_destroy do
    obj = Top50Object.find(self.id)
    obj.destroy!
  end
end

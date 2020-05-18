class Top50BenchmarkResult < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"  
  belongs_to :top50_benchmark, foreign_key: "benchmark_id"
  belongs_to :top50_machine, foreign_key: "machine_id"
  
  before_save do
    if self.new_record?
      b_typeid = Top50ObjectType.where(name_eng: "Benchmark result").first.id
      obj = Top50Object.new
      obj[:type_id] = b_typeid
      obj[:is_valid] = self.is_valid
      obj[:comment] = format('New benchmark result (%s)', self.comment)
      obj.save!
      self.id = obj.id
    end
    if self.is_valid != self.top50_object.is_valid
      self.top50_object.update(is_valid: self.is_valid)
    end
  end

  before_destroy do
    obj = Top50Object.find(self.id)
    obj.destroy!
  end

  def confirm
    if self.is_valid != 1
      self.is_valid = 1
      self.save
    end
    self.top50_object.confirm
  end

end

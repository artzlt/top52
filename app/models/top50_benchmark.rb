class Top50Benchmark < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"  
  belongs_to :top50_measure_unit, foreign_key: "measure_id"
  has_many :top50_benchmark_results, foreign_key: "benchmark_id"
end

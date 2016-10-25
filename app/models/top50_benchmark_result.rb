class Top50BenchmarkResult < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :top50_object, foreign_key: "id"  
  belongs_to :top50_benchmark, foreign_key: "benchmark_id"
  belongs_to :top50_machine, foreign_key: "machine_id"
end

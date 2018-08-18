class Top50MeasureUnit < ActiveRecord::Base
  has_many :top50_benchmarks, foreign_key: "measure_id"
end

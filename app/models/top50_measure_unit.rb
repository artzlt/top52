class Top50MeasureUnit < ActiveRecord::Base
  has_many :top50_benchmarks, foreign_key: "measure_id"
  has_many :top50_measure_scales, foreign_key: "measure_unit_id", dependent: :destroy
end

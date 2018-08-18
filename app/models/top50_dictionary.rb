class Top50Dictionary < ActiveRecord::Base
  has_many :top50_dictionary_elems, foreign_key: "dict_id", dependent: :destroy
  has_many :top50_attribute_dicts, foreign_key: "dict_id"
end

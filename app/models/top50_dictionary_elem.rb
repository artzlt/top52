class Top50DictionaryElem < ActiveRecord::Base
  belongs_to :top50_dictionary, foreign_key: "dict_id"
  has_many :top50_attribute_val_dicts, foreign_key: "dict_elem_id"

  scope :finder, ->(q){ where("name like :q", q: "%#{q.mb_chars}%").order(:name) }

  def as_json(options)
    { id: id, text: name }
  end

end

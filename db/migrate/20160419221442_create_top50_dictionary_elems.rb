class CreateTop50DictionaryElems < ActiveRecord::Migration
  def change
    create_table :top50_dictionary_elems do |t|
      t.string :name
      t.string :name_eng
      t.integer :dict_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end

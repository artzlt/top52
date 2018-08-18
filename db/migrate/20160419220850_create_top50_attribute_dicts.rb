class CreateTop50AttributeDicts < ActiveRecord::Migration
  def change
    create_table :top50_attribute_dicts, :id => false do |t|
      t.integer :id
      t.integer :dict_id

      t.timestamps
    end
  end
end

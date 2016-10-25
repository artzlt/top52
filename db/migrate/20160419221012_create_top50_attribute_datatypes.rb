class CreateTop50AttributeDatatypes < ActiveRecord::Migration
  def change
    create_table :top50_attribute_datatypes do |t|
      t.string :db_code

      t.timestamps
    end
  end
end

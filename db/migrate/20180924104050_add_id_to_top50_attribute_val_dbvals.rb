class AddIdToTop50AttributeValDbvals < ActiveRecord::Migration
  def change
    add_column :top50_attribute_val_dbvals, :id, :primary_key
  end
end

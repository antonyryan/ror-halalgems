class AddPropertyTypeIdToListing < ActiveRecord::Migration
  def change
  	add_column :listings, :property_type_id, :integer
  	add_index :listings, :property_type_id
  end
end

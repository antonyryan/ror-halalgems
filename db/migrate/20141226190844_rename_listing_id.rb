class RenameListingId < ActiveRecord::Migration
  def change  	
  	remove_column :property_photos, :lisitng_id, :integer  	

  	add_column :property_photos, :listing_id, :integer  	
  	add_index :property_photos, :listing_id  	
  end
end

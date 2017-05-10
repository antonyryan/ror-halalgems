class AddIndexToFloorplan < ActiveRecord::Migration
  def change
  	remove_column :property_floorplans, :lisitng_id, :integer  	

  	add_column :property_floorplans, :listing_id, :integer  	
  	add_index :property_floorplans, :listing_id  
  end
end

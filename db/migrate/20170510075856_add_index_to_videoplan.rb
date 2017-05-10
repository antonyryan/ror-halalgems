class AddIndexToVideoplan < ActiveRecord::Migration
  def change
  	remove_column :property_videos, :lisitng_id, :integer  	

  	add_column :property_videos, :listing_id, :integer  	
  	add_index :property_videos, :listing_id 
  end
end

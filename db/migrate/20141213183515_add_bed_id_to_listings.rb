class AddBedIdToListings < ActiveRecord::Migration
  def change
  	remove_index :listings, :beds_id
  	remove_column :listings, :beds_id, :integer  	

  	add_column :listings, :bed_id, :integer  	
  	add_index :listings, :bed_id  	
  end
end

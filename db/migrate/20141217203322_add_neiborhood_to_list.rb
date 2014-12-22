class AddNeiborhoodToList < ActiveRecord::Migration
  def change
  	add_column :listings, :neighborhood_id, :integer  	
  	add_index :listings, :neighborhood_id  	
  end
end

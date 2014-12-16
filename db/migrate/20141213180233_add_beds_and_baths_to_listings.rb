class AddBedsAndBathsToListings < ActiveRecord::Migration
  def change
  	add_column :listings, :beds_id, :integer
  	add_column :listings, :full_baths_no, :integer
  	add_column :listings, :half_baths_no, :integer

  	add_index :listings, :beds_id
  end
end

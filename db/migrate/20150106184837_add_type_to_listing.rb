class AddTypeToListing < ActiveRecord::Migration
  def change
    add_column :listings, :listing_type_id, :integer
    add_index :listings, :listing_type_id
  end
end

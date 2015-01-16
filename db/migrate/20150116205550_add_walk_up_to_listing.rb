class AddWalkUpToListing < ActiveRecord::Migration
  def change
    add_column :listings, :walk_up, :boolean, default: false
  end
end

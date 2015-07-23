class AddYardToListing < ActiveRecord::Migration
  def change
    add_column :listings, :yard, :boolean, default: false
    add_column :listings, :patio, :boolean, default: false
  end
end

class AddLandlordToListings < ActiveRecord::Migration
  def change
    add_column :listings, :landlord, :string
  end
end

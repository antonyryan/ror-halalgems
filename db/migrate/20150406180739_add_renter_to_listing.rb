class AddRenterToListing < ActiveRecord::Migration
  def change
    add_column :listings, :renter, :string
  end
end

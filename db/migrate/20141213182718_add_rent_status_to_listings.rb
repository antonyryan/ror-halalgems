class AddRentStatusToListings < ActiveRecord::Migration
  def change
  	add_column :listings, :status_id, :integer
  end
end

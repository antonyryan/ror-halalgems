class AddAccessToListing < ActiveRecord::Migration
  def change
    add_column :listings, :access, :string
  end
end

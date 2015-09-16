class AddFakeAddresstToListing < ActiveRecord::Migration
  def change
    add_column :listings, :fake_address, :string
  end
end

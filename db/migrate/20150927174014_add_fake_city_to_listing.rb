class AddFakeCityToListing < ActiveRecord::Migration
  def change
    add_column :listings, :fake_city_id, :integer
    add_column :listings, :fake_unit_no, :string
  end
end

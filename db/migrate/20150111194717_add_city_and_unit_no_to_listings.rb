class AddCityAndUnitNoToListings < ActiveRecord::Migration
  def change
    add_column :listings, :city_id, :integer
    add_column :listings, :unit_no, :string

    add_index :listings, :city_id
  end
end

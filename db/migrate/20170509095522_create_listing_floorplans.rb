class CreateListingFloorplans < ActiveRecord::Migration
  def change
    create_table :property_floorplans do |t|
      t.string :floorplan_url
      t.integer :lisitng_id

      t.timestamps
    end
  end
end

class CreateListingNeighborhoods < ActiveRecord::Migration
  def change
    create_table :listing_neighborhoods do |t|
      t.integer :listing_id
      t.integer :neighborhood_id
    end
  end
end

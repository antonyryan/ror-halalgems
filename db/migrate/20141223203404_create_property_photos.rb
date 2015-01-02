class CreatePropertyPhotos < ActiveRecord::Migration
  def change
    create_table :property_photos do |t|
      t.string :photo_url
      t.integer :lisitng_id

      t.timestamps
    end
  end
end

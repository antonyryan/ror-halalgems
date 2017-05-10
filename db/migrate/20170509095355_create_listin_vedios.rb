class CreateListinVedios < ActiveRecord::Migration
  def change
    create_table :property_videos do |t|
      t.string :video_url
      t.integer :lisitng_id

      t.timestamps
    end
  end
end

class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :listing_id, null: false
      t.integer :user_id, null: false
    end
    add_index :favorites, [:listing_id, :user_id], unique: true
  end
end

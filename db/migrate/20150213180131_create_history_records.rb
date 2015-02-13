class CreateHistoryRecords < ActiveRecord::Migration
  def change
    create_table :history_records do |t|
      t.string :message
      t.integer :listing_id
    end

    add_index :history_records, :listing_id
  end
end

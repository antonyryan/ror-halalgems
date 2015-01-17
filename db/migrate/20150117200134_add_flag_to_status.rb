class AddFlagToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :is_for_rentals, :boolean, default: false
  end
end

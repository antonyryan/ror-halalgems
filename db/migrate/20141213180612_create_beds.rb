class CreateBeds < ActiveRecord::Migration
  def change
    create_table :beds do |t|
      t.string :name

      t.timestamps
    end
  end
end

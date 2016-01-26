class CreateSpaceTypes < ActiveRecord::Migration
  def change
    create_table :space_types do |t|
      t.string :name
    end
  end
end

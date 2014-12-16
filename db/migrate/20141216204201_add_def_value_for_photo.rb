class AddDefValueForPhoto < ActiveRecord::Migration
  def up
  change_column :listings, :main_photo, :string, default: 'bwtxlr5idgsezlkw7dvp.jpg'
end

def down
  change_column :listings, :main_photo, :string, default: nil
end
end

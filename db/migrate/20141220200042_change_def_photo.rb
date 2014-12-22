class ChangeDefPhoto < ActiveRecord::Migration
	def up
	  change_column :listings, :main_photo, :string, default: 'wzupztbtjzhe0fi3fpda.jpg'
	end

	def down
	  change_column :listings, :main_photo, :string, default: nil
	end
end

class PropertyPhoto < ActiveRecord::Base
	belongs_to :listing	
	mount_uploader :photo_url, ListingPhotoUploader
end

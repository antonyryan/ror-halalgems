class PropertyPhoto < ActiveRecord::Base
	belongs_to :listing	
	mount_uploader :photo_url, ListingPhotoUploader
  default_scope { order('coalesce("property_photos"."order_num", 1000)') }
end

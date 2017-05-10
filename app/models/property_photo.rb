puts "property photos"
class PropertyPhoto < ActiveRecord::Base
	belongs_to :listing
  default_scope { order('coalesce("property_photos"."order_num", 1000)') }
	mount_uploader :photo_url, ListingPhotoUploader
end
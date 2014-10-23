class Listing < ActiveRecord::Base
	belongs_to :user

	validates :street_address, presence: true

	mount_uploader :main_photo, ListingPhotoUploader
end

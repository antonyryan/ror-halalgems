class Listing < ActiveRecord::Base
	belongs_to :user
	belongs_to :status
	belongs_to :bed
	belongs_to :neighborhood
	belongs_to :property_type
	
	validates :street_address, presence: true
	validates :price, numericality: { greater_than: 0 } 

	validates :full_baths_no, numericality: { only_integer: true, greater_than: 0 }  
	validates :half_baths_no, numericality: { only_integer: true, greater_than: 0 }  

	scope :beds, -> (bed_id) { where bed_id: bed_id } 
	scope :neighborhood_filter, -> (neighborhood_id) { where neighborhood_id: neighborhood_id } 
	scope :type_filter, -> (property_type_id) { where property_type_id: property_type_id } 
	scope :min_price, -> (price) { where("price >= ?", price) }  		
	scope :max_price, -> (price) { where("price <= ?", price) }  	 	

	scope :min_full_baths, -> (full_baths_no) { where("full_baths_no >= ?", full_baths_no) }  		
	scope :max_full_baths, -> (full_baths_no) { where("full_baths_no <= ?", full_baths_no) }  

	scope :min_half_baths, -> (half_baths_no) { where("half_baths_no >= ?", half_baths_no) }  		
	scope :max_half_baths, -> (half_baths_no) { where("half_baths_no <= ?", half_baths_no) } 
	

	mount_uploader :main_photo, ListingPhotoUploader
end

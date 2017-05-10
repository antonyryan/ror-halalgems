puts "property floorplan"

class PropertyFloorplan < ActiveRecord::Base
	belongs_to :listing
	 default_scope { order('coalesce("property_floorplans"."order_num", 1000)') }
	mount_uploader :floorplan_url, ListingFloorplanUploader
end
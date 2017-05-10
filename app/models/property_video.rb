class PropertyVideo < ActiveRecord::Base
  belongs_to :listing
  default_scope { order('coalesce("property_videos"."order_num", 1000)') }
	mount_uploader :video_url, ListingVideoUploader
end
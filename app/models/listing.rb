class Listing < ActiveRecord::Base
	belongs_to :user
	belongs_to :listing_type
	belongs_to :status
	belongs_to :bed
	belongs_to :neighborhood
	belongs_to :property_type
  belongs_to :city
	has_many :property_photos
	accepts_nested_attributes_for :property_photos, allow_destroy: true

	validates :street_address, presence: true
	validates :price, allow_blank: true, numericality: { greater_than: 0 }

	validates :full_baths_no, allow_blank: true, numericality: { only_integer: true, greater_than: 0 }
	validates :half_baths_no, allow_blank: true, numericality: { only_integer: true, greater_than: 0 }

	scope :listing_type_filter, -> (listing_type_id) { where listing_type_id: listing_type_id }
	scope :beds, -> (bed_id) { where bed_id: bed_id }

	scope :neighborhood_filter, -> (neighborhood_id) { where neighborhood_id: neighborhood_id.split(',') }

	scope :type_filter, -> (property_type_id) { where property_type_id: property_type_id }
	scope :min_price, -> (price) { where("price >= ?", price) }
	scope :max_price, -> (price) { where("price <= ?", price) }

  scope :full_baths, -> (full_baths_no) { where(full_baths_no: full_baths_no) }
  scope :half_baths, -> (half_baths_no) { where(half_baths_no: half_baths_no) }

	scope :min_full_baths, -> (full_baths_no) { where("full_baths_no >= ?", full_baths_no) }
	scope :max_full_baths, -> (full_baths_no) { where("full_baths_no <= ?", full_baths_no) }

	scope :min_half_baths, -> (half_baths_no) { where("half_baths_no >= ?", half_baths_no) }
	scope :max_half_baths, -> (half_baths_no) { where("half_baths_no <= ?", half_baths_no) }


	mount_uploader :main_photo, ListingPhotoUploader

  def city_name
    city.try :name
  end

  def city_name=(name)
    if name.present?
      c = City.find_or_create_by(name: name)
      self.city_id = c.id
    end
  end
end

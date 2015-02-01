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

  scope :agent_filter, -> (agent_id) { where user_id: agent_id }

  scope :dishwasher_filter, -> (dishwasher) { where dishwasher: dishwasher != '0' }
  scope :backyard_filter, -> (backyard) { where backyard: backyard != '0' }
  scope :balcony_filter, -> (balcony) { where balcony: balcony != '0' }
  scope :elevator_filter, -> (elevator) { where elevator: elevator != '0' }
  scope :walk_up_filter, -> (walk_up) { where walk_up: walk_up != '0' }
  scope :laundry_in_building_filter, -> (laundry_in_building) { where laundry_in_building: laundry_in_building != '0' }
  scope :laundry_in_unit_filter, -> (laundry_in_unit) { where laundry_in_unit: laundry_in_unit != '0' }
  scope :live_in_super_filter, -> (live_in_super) { where live_in_super: live_in_super != '0' }
  scope :absentee_landlord_filter, -> (absentee_landlord) { where absentee_landlord: absentee_landlord != '0' }


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

  def full_address
    unless @full_address
      address = ''

      unless street_address.empty?
        address += "#{street_address}, "
      end

      address += neighborhood.try :name unless neighborhood.nil?

      @full_address = address
    end

    @full_address
  end

  def days_on_market
    (Date.current - created_at.to_date).to_i
  end

  def features
    f = []

    f.push('dishwasher') if self.dishwasher?
    f.push('backyard') if self.backyard?
    f.push('balcony') if self.balcony?
    f.push('elevator') if self.elevator?
    f.push('laundry in building') if self.laundry_in_building?
    f.push('laundry in unit') if self.laundry_in_unit?
    f.push('live-in super') if self.live_in_super?
    f.push('absentee landlord') if self.absentee_landlord?
    f.push('walk up') if self.walk_up?

    f.join ', '
  end

  def pets
    p = []
    p.push('no pets') if self.no_pets?
    p.push('cats') if self.cats?
    p.push('dogs') if self.dogs?
    p.push('approved pets only') if self.approved_pets_only?

    p.join ', '
  end

  def utilities
    u = []
    u.push('heat_and_hot_water') if self.heat_and_hot_water?
    u.push('gas') if self.gas?
    u.push('all') if self.all_utilities?
    u.push('none') if self.none?

    u.join ', '
  end


end

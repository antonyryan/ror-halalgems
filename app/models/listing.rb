class Listing < ActiveRecord::Base
  belongs_to :user
  belongs_to :listing_type
  belongs_to :status
  belongs_to :bed
  belongs_to :neighborhood
  belongs_to :property_type
  belongs_to :city
  belongs_to :fake_city, class_name: 'Neighborhood', foreign_key: 'fake_city_id'
  has_many :property_photos, dependent: :destroy
  has_many :history_records
  accepts_nested_attributes_for :property_photos, allow_destroy: true

  before_save :set_status

  validates :street_address, presence: true
  validates :price, allow_blank: true, numericality: {greater_than: 0}

  validates :full_baths_no, allow_blank: true, numericality: {only_integer: true, greater_than: 0}
  validates :half_baths_no, allow_blank: true, numericality: {only_integer: true, greater_than: 0}

  validates :available_date, presence: true
  validates :landlord, presence: true

  scope :hidden_listings, -> { where(status_id: Status.where(name: ['Rented', 'Lost', 'Closed', 'Temporary off market'])) }
  scope :available_listings, -> { where(status_id: Status.where.not(name: ['Rented', 'Lost', 'Closed', 'Temporary off market'])) }
  scope :pending_listings, -> { where(status_id: Status.where(name: 'Deposit/Pending Application')) }

  scope :street_address_search, -> (street_address) { where('street_address like ?', "%#{street_address}%") }
  scope :listing_type_filter, -> (listing_type_id) { where listing_type_id: listing_type_id }
  scope :beds, -> (bed_id) { where bed_id: bed_id }

  scope :neighborhood_filter, -> (neighborhood_id) { where neighborhood_id: neighborhood_id.split(',') }

  scope :type_filter, -> (property_type_id) { where property_type_id: property_type_id }
  scope :min_price, -> (price) { where('price >= ?', price) }
  scope :max_price, -> (price) { where('price <= ?', price) }

  scope :full_baths, -> (full_baths_no) { where(full_baths_no: full_baths_no) }
  scope :half_baths, -> (half_baths_no) { where(half_baths_no: half_baths_no) }

  scope :min_full_baths, -> (full_baths_no) { where('full_baths_no >= ?', full_baths_no) }
  scope :max_full_baths, -> (full_baths_no) { where('full_baths_no <= ?', full_baths_no) }

  scope :min_half_baths, -> (half_baths_no) { where('half_baths_no >= ?', half_baths_no) }
  scope :max_half_baths, -> (half_baths_no) { where('half_baths_no <= ?', half_baths_no) }

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
  scope :parking_available_filter, -> (parking_available) { where parking_available: parking_available != '0' }
  scope :storage_available_filter, -> (storage_available) { where storage_available: storage_available != '0' }
  scope :yard_filter, -> (yard) { where yard: yard != '0' }
  scope :patio_filter, -> (patio) { where patio: patio != '0' }


  scope :no_pets_filter, -> (no_pets) { where no_pets: no_pets != '0' }
  scope :cats_filter, -> (cats) { where cats: cats != '0' }
  scope :dogs_filter, -> (dogs) { where dogs: dogs != '0' }
  scope :approved_pets_only_filter, -> (approved_pets_only) { where approved_pets_only: approved_pets_only != '0' }

  scope :heat_filter, -> (heat) { where heat_and_hot_water: heat != '0' }
  scope :gas_filter, -> (gas) { where gas: gas != '0' }
  scope :all_filter, -> (all_utilities) { where all_utilities: all_utilities != '0' }
  scope :none_filter, -> (none) { where none: none != '0' }

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

    f.push('Dishwasher') if self.dishwasher?
    f.push('Backyard') if self.backyard?
    f.push('Balcony') if self.balcony?
    f.push('Elevator') if self.elevator?
    f.push('Laundry in building') if self.laundry_in_building?
    f.push('Laundry in unit') if self.laundry_in_unit?
    f.push('Live-in super') if self.live_in_super?
    f.push('Absentee landlord') if self.absentee_landlord?
    f.push('Walk up') if self.walk_up?
    f.push('Parking available') if self.parking_available?
    f.push('Storage available') if self.storage_available?
    f.push('Yard') if self.yard?
    f.push('Patio') if self.patio?

    f.join ', '
  end

  def pets
    p = []
    p.push('No pets') if self.no_pets?
    p.push('Cats') if self.cats?
    p.push('Dogs') if self.dogs?
    p.push('Approved pets only') if self.approved_pets_only?

    p.join ', '
  end

  def utilities
    u = []
    u.push('Heat and hot water') if self.heat_and_hot_water?
    u.push('Gas') if self.gas?
    u.push('All') if self.all_utilities?
    u.push('None') if self.none?

    u.join ', '
  end

  def headline
    if title.present?
      title
    else
      neighborhood.try(:name)
    end
  end

    private
    def set_status
      if self.price_changed? and not self.new_record?
        self.status = Status.where(name: 'Price change', is_for_rentals: self.listing_type_id==0).first
      end
    end


  end

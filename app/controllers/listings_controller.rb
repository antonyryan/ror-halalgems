class ListingsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:edit, :update, :destroy, :copy]

  # helper_method :sort_column, :sort_direction

  def index
		if sort_column.include? '.'
      parts = sort_column.split('.')
      @listings = Listing.includes(parts.first).order("#{parts.first.pluralize}.#{parts.last}" + ' ' + sort_direction)
    else
      @listings = Listing.order(sort_column + ' ' + sort_direction)
    end

    if params[:hidden_listings].present?
      @listings = @listings.hidden_listings
    else
      @listings = @listings.available_listings
    end

    @listings = @listings.street_address_search(params[:street_address]) if params[:street_address].present?
    @listings = @listings.listing_type_filter(params[:listing_type_id]) if params[:listing_type_id].present?
		@listings = @listings.type_filter(params[:property_type]) if params[:property_type].present?
		@listings = @listings.beds(params[:beds]) if params[:beds].present?
		@listings = @listings.neighborhood_filter(params[:neighborhood_ids]) if params[:neighborhood_ids].present?
		@listings = @listings.min_price(params[:price_from]) if params[:price_from].present?
		@listings = @listings.max_price(params[:price_to]) if params[:price_to].present?

		@listings = @listings.full_baths(params[:full_baths]) if params[:full_baths].present?

		@listings = @listings.half_baths(params[:half_baths]) if params[:half_baths].present?
    @listings = @listings.agent_filter(params[:agent_id]) unless params[:agent_id].blank?

    @listings = @listings.dishwasher_filter(params[:dishwasher]) if params[:dishwasher].present?
    @listings = @listings.backyard_filter(params[:backyard]) if params[:backyard].present?
    @listings = @listings.balcony_filter(params[:balcony]) if params[:balcony].present?
    @listings = @listings.elevator_filter(params[:elevator]) if params[:elevator].present?
    @listings = @listings.walk_up_filter(params[:walk_up]) if params[:walk_up].present?
    @listings = @listings.laundry_in_building_filter(params[:laundry_in_building]) if params[:laundry_in_building].present?
    @listings = @listings.laundry_in_unit_filter(params[:laundry_in_unit]) if params[:laundry_in_unit].present?
    @listings = @listings.live_in_super_filter(params[:live_in_super]) if params[:live_in_super].present?
    @listings = @listings.absentee_landlord_filter(params[:absentee_landlord]) if params[:absentee_landlord].present?



    @neighborhoods_json = ''
    if params['neighborhood_ids'].present?
      @neighborhoods_json = Neighborhood.where(id: params['neighborhood_ids'].split(',')).map(&:attributes).to_json
    end

    @sale_id = ListingType.find_by(name: 'Sale').id
    @rental_id = ListingType.find_by(name: 'Rental').id

    respond_to do |format|
      format.html{
        @listings = @listings.paginate(page: params[:page])
      }
      format.pdf {
        render :pdf => "index"
      }
    end

		#if params[:display].present?
		#	@display = params[:display]
		#else
		#	@display = 'thumb_list'
		#end
	end

	def show
		@listing = Listing.find(params[:id])
		#@photo_urls = @listing.property_photos.all
    respond_to do |format|
      format.html
      format.pdf {
        render :pdf => "show"
      }
    end
end

	def edit
		@listing = Listing.find(params[:id])		
	end

	def update
		@listing = Listing.find(params[:id])		

		# if params[:main_photo].present?
		#   preloaded = Cloudinary::PreloadedFile.new(params[:main_photo])         
		#   raise "Invalid upload signature" if !preloaded.valid?
		#   @listing.main_photo = preloaded.identifier
		# end
		old_status_id = @listing.status_id
		if @listing.update_attributes(listing_params)
			flash[:success] = "Listing updated"
      if old_status_id != @listing.status_id
        history =  @listing.history_records.build
        history.message = "Status changed from '#{Status.find(old_status_id).try(:name)}' to '#{@listing.status.name}' by #{current_user.name}"
        history.save
			  AgentMailer.listing_changed(@listing, Status.find(old_status_id).try(:name), @listing.status.name).deliver
      end
			redirect_to @listing
		else
			render 'edit'
		end
	end

	def new
		@listing = current_user.listings.build
		if params[:listing_type_id].present?
			@listing.listing_type_id = params[:listing_type_id]
		end
	end

	def create
		if params[:Neighborhood].present?
			neighborhood = Neighborhood.find_by_name(params[:Neighborhood])
			if neighborhood.nil?
				neighborhood = Neighborhood.create(name: params[:Neighborhood])	
			end
			if neighborhood.id != params[:listing][:neighborhood_id]
				params[:listing][:neighborhood_id] = neighborhood.id
			end
		end

		@listing = current_user.listings.build(listing_params)
		
	    if @listing.save
        AgentMailer.listing_created(@listing).deliver
	      flash[:success] = 'Listing created.'
	      redirect_to @listing
	    else
	      render 'new'
	    end
  end

  def destroy
    @listing = Listing.find(params[:id])

    @listing.destroy
    flash[:success] = "Listing deleted."
    redirect_to listings_url
  end

  def copy
    @listing = Listing.find(params[:id])
    @new_listing = @listing.dup

    if @new_listing.save
      @listing.property_photos.each do |photo|
        p = photo.dup
        p.listing_id =@new_listing.id
        p.save
      end
      flash[:success] = 'Listing copied.'
      redirect_to @new_listing
    else
      flash[:error] = 'Error.'
      redirect_back_or @listing
    end
  end

private

    def listing_params
      params.require(:listing).permit(:street_address, :listing_type_id, :main_photo, :price, :status_id, :bed_id, 
      	:full_baths_no, :half_baths_no, :neighborhood_id, :property_type_id, :city_name, :unit_no, :available_date,
        :description, :landlord,
        :dishwasher, :backyard, :balcony, :elevator,
        :laundry_in_building, :laundry_in_unit, :live_in_super, :absentee_landlord, :walk_up,
        :no_pets, :cats, :dogs, :approved_pets_only,
        :heat_and_hot_water, :gas, :all_utilities, :none,
      	property_photos_attributes: [:id, :photo_url, :_destroy])
    end

  def correct_user
    user = Listing.find(params[:id]).user
    redirect_to(root_url) unless current_user?(user) || current_user.admin?
  end


end

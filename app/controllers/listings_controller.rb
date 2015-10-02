class ListingsController < ApplicationController
  require 'prawnto'
  before_filter :index_page_filter, only: [:index]
  before_filter :signed_in_user, except: [:index]
  before_filter :correct_user, only: [:edit, :update, :destroy, :copy]

  # helper_method :sort_column, :sort_direction

  def index
    if sort_column.include? '.'
      parts = sort_column.split('.')
      @listings = Listing.includes(parts.first).order("#{parts.first.pluralize}.#{parts.last}" + ' ' + sort_direction)
    else
      @listings = Listing.order(sort_column + ' ' + sort_direction)
    end

    if params[:status].present?
      if params[:status] == 'Active'
        @listings = @listings.available_listings
      elsif params[:status] == 'Unavailable'
        @listings = @listings.hidden_listings
      elsif params[:status] == 'Pending'
        @listings = @listings.pending_listings
      end
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
    @listings = @listings.parking_available_filter(params[:parking_available]) if params[:parking_available].present?
    @listings = @listings.storage_available_filter(params[:storage_available]) if params[:storage_available].present?
    @listings = @listings.yard_filter(params[:yard]) if params[:yard].present?
    @listings = @listings.patio_filter(params[:patio]) if params[:patio].present?

    @listings = @listings.no_pets_filter(params[:no_pets]) if params[:no_pets].present?
    @listings = @listings.cats_filter(params[:cats]) if params[:cats].present?
    @listings = @listings.dogs_filter(params[:dogs]) if params[:dogs].present?
    @listings = @listings.approved_pets_only_filter(params[:approved_pets_only]) if params[:approved_pets_only].present?

    @listings = @listings.heat_filter(params[:heat]) if params[:heat].present?
    @listings = @listings.gas_filter(params[:gas]) if params[:gas].present?
    @listings = @listings.all_filter(params[:all_utilities]) if params[:all_utilities].present?
    @listings = @listings.none_filter(params[:none]) if params[:none].present?

    @neighborhoods_json = ''
    if params['neighborhood_ids'].present?
      @neighborhoods_json = Neighborhood.where(id: params['neighborhood_ids'].split(',')).map(&:attributes).to_json
    end

    @sale_id = ListingType.find_by(name: 'Sale').id
    @rental_id = ListingType.find_by(name: 'Rental').id

    respond_to do |format|
      format.html {
        @listings = @listings.paginate(page: params[:page])
      }
      format.pdf {
        render pdf: 'index'
      }
      format.xml do
        if params[:to].to_s.downcase == 'nakedapartments'
          @listings = Listing.where(export_to_nakedapartments: true)
        elsif params[:to].to_s.downcase == 'streeteasy'
          @listings = Listing.where(export_to_streeteasy: true)
        else
          @listings = []
        end

        unless @listings.empty?
          if params[:type].to_s.downcase == 'rental'
            @listings = @listings.listing_type_filter(ListingType.find_by_name('Rental').id)
          elsif params[:type].to_s.downcase == 'sale'
            @listings = @listings.listing_type_filter(ListingType.find_by_name('Sale').id)
          elsif params[:type].to_s.downcase == 'all'
            @listings = @listings
          else
            @listings = []
          end
        end

      end
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
        prawnto :inline=>true, :prawn=>{:margin=>20}
        render :pdf => 'show'
      }
      format.xml
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
        history = @listing.history_records.build
        history.message = "Status changed from '#{Status.find(old_status_id).try(:name)}' to '#{@listing.status.name}' by #{current_user.name}"
        history.save
        AgentMailer.listing_changed(@listing, Status.find(old_status_id).try(:name), @listing.status.name).deliver
      end

      # xml_content = render_to_string :action => 'show', :formats => [:xml]
      # url = URI.parse('http://myastoriarealestate.com/xml/')
      # url = URI.parse('http://127.0.0.1:3000/xml/')
      # request = Net::HTTP::Post.new(url.path)
      # request.body = xml_content
      # request.content_type = 'text/xml'
      # request.content_length =xml_content.bytesize()
      # response = Net::HTTP.request #start(url.host, url.port) {|http| http.request(request)}

      # HTTParty.post('http://127.0.0.1:3000/xml/', :body => xml_content )
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

  def create_email
    if not params[:listing_ids].present?
      flash[:error] = 'Selection is empty'
      redirect_to listings_path
    else
      @listings = Listing.find(params[:listing_ids])
    end
  end

  def send_email
    if not params[:listing_ids].present?
      flash[:error] = 'Selection is empty'
      redirect_to listings_path
    else
      @listings = Listing.find(params[:listing_ids])
      if params[:email].present?
        ListingMailer.client(params[:email], @listings, current_user.id).deliver
        flash[:success] = 'Email sent'
        redirect_to listings_path
      else
        flash[:error] = 'Email can' 't be blank'
        render 'create_email'
      end
    end
  end

  private
  def index_page_filter
    unless request.format.xml?
      signed_in_user
    end
  end

  def listing_params
    params.require(:listing).permit(:street_address, :listing_type_id, :main_photo, :price, :status_id, :bed_id,
                                    :full_baths_no, :half_baths_no, :neighborhood_id, :property_type_id, :city_name, :unit_no, :available_date,
                                    :description, :landlord, :renter, :title,
                                    :dishwasher, :backyard, :balcony, :elevator,
                                    :laundry_in_building, :laundry_in_unit, :live_in_super, :absentee_landlord, :walk_up,
                                    :storage_available, :parking_available, :yard, :patio,
                                    :no_pets, :cats, :dogs, :approved_pets_only,
                                    :heat_and_hot_water, :gas, :all_utilities, :none, :export_to_streeteasy, :export_to_nakedapartments, :fake_address,
                                    :access, :fake_city_id, :fake_unit_no, :hide_address_for_nakedapartments,
                                    property_photos_attributes: [:id, :photo_url, :_destroy])
  end

  def correct_user
    user = Listing.find(params[:id]).user
    redirect_to(root_url) unless current_user?(user) || current_user.admin?
  end


end

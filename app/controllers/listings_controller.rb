class ListingsController < ApplicationController
	def index
		@listings = Listing.all
		@listings = @listings.beds(params[:beds]) if params[:beds].present?
		@listings = @listings.min_price(params[:price_from]) if params[:price_from].present?
		@listings = @listings.max_price(params[:price_to]) if params[:price_to].present?

		@listings = @listings.min_full_baths(params[:full_baths_from]) if params[:full_baths_from].present?
		@listings = @listings.max_full_baths(params[:full_baths_to]) if params[:full_baths_to].present?

		@listings = @listings.min_half_baths(params[:half_baths_from]) if params[:half_baths_from].present?
		@listings = @listings.max_half_baths(params[:half_baths_to]) if params[:half_baths_to].present?
		
		@listings = @listings.paginate(page: params[:page])
	end

	def show
		@listing = Listing.find(params[:id])
	end

	def edit
		@listing = Listing.find(params[:id])
	end

	def update
		@listing = Listing.find(params[:id])
		if @listing.update_attributes(listing_params)
			flash[:success] = "Listing updated"
			redirect_to @listing
		else
			render 'edit'
		end
	end

	def new
		@listing = current_user.listings.build
	end

	def create
		@listing = current_user.listings.build(listing_params)
	    if @listing.save	      
	      flash[:success] = "Listing created."
	      redirect_to @listing
	    else
	      render 'new'
	    end
	end

private

    def listing_params
      params.require(:listing).permit(:street_address, :main_photo, :price, :status_id, :bed_id, 
      	:full_baths_no, :half_baths_no)
    end
end

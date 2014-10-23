class ListingsController < ApplicationController
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

private

    def listing_params
      params.require(:listing).permit(:street_address, :main_photo, :price)
    end
end

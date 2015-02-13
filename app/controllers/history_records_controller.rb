class HistoryRecordsController < ApplicationController
  def index
    if params[:listing_id].present?
      @listing = Listing.find params[:listing_id]
    else
      flash[:error] = "Listing not found"
      redirect_back_or listings_path
    end
  end
end

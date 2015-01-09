class ListingNeighborhood < ActiveRecord::Base
  belongs_to :listing
  belongs_to :neighborhood
end

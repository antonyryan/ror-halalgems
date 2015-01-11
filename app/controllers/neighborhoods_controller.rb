class NeighborhoodsController < ApplicationController
  def index
  	respond_to do |format|			
			format.json do 				
				render :json => Neighborhood.where("name like ?", "%#{params[:term]}%").map{|neighborhood| {id: neighborhood.id, name: neighborhood.name, value: neighborhood.name}}
			end			
		end
  	end
end

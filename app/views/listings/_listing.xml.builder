xml.property(id: listing.id, type: listing.listing_type.try(:name), #.downcase,
             status: status_for_export(listing.status.try(:name)), url: listing_url(listing) ) do
  xml.location do
    if params[:to].to_s.downcase == 'nakedapartments'
      xml.address listing.street_address
    else
      xml.address listing.fake_address
    end
    # todo: required!
    xml.apartment listing.unit_no
    xml.city 'New York'
    xml.state 'NY'
    xml.zipcode listing.zip_code

    xml.neighborhood listing.neighborhood.try(:name)
  end

  xml.details do
    xml.price listing.price
    # <noFee/> <!-- include if no fee -->
    # <maintenance/> <!-- monthly (Also Common Charges for condos) -->
    # <exclusive> If this is an exclusive listing include this tag. If it is not exclusive then leave this tag out.
    # <taxes/> <!-- monthly -->
    xml.bedrooms bed_for_export(listing.bed.name)
    xml.bathrooms listing.full_baths_no
    xml.half_baths listing.half_baths_no
    # todo: required!
    xml.totalrooms bed_for_export(listing.bed.name) + listing.full_baths_no.to_i + listing.half_baths_no.to_i

    xml.squareFeet listing.size
    # <lotarea> Area of the lot in whole or partial acres, examples: '3', '0.85'
    # <lotsize></lotsize> Dimensions of the lot as length and width in linear feet, examples: '20x40', '60x90'

    # <availableon></availableon> If this is a rental property the date the property becomes available for move in. Example 2006-09-25
    xml.availableOn listing.available_date
    # <listedon></listedon> If this property is already on the market this should be the date it was first listed. Example: 2006-09-21
    # <soldon></soldon> If this property is sold, this should be the date that it sold on. Example: 2006-05-22

    # Description of the property. Should not contain any HTML or XML tags. Any special characters should be escaped, Please use CDATA if listing descriptions include line breaks.
    # todo: check for line breaks
    xml.description listing.description

    xml.propertyType property_type_for_export(listing.property_type.name)
    # <mlsid></mlsid> The id number in the associated MLS
    # <mlsname></mlsname> The name of the MLS that this listing is listed in.
    # <built></built> Date or year the property was originally built

    # xml.landlord listing.landlord

    xml.amenities do
      # <doorman></doorman>
      # <prewar></prewar>
      # <gym></gym>
      # <pool></pool>

      if listing.elevator?
        xml.elevator
      end
      # <garage></garage>
      if listing.parking_available?
        xml.parking
      end
      if listing.balcony?
        xml.balcony
      end
      if listing.storage_available?
        xml.storage
      end
      if listing.patio?
        xml.patio
      end
      # <fireplace></fireplace>
      # <washerdryer></washerdryer>
      # <furnished></furnished>

      # <pets></pets> Does this property allow pets
      # todo: do pets
      if listing.dishwasher?
        xml.dishwasher
      end

      # <other></other>A comma delimited string of other amenities
    #   todo: do other
    end

    # todo: move to other
    # xml.utilities do
    #   if listing.heat_and_hot_water?
    #     xml.heatandhotwater
    #   end
    #   if listing.gas?
    #     xml.gas
    #   end
    #   if listing.all_utilities?
    #     xml.all
    #   end
    #   if listing.none?
    #     xml.none
    #   end
    # end
  end

  xml.agents do
    xml.agent(id: listing.user.id) do
      xml.name listing.user.name
      # <company>	optional	Name of the company this agent works for, example: Eastside Realty
      xml.photo listing.user.avatar_url

      # todo: Required!
      xml.email listing.user.email
      xml.phone_numbers do
        xml.office listing.user.phone
        xml.fax listing.user.fax
      end
    end
  end

  xml.media do
    listing.property_photos.each do |photo|
      xml.photo(url: photo.photo_url_url)
    end
  end
end

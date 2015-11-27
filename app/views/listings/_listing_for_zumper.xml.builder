xml.property do
  xml.location do
    xml.tag!('unit-number') { xml.text! listing.unit_no }
    xml.tag!('street-address') { xml.text! listing.street_address }
    xml.tag!('city-name') { xml.text! listing.neighborhood.try(:name) }
    xml.tag!('state-code') { xml.text! 'NY' }
    xml.zipcode listing.zip_code
    #   <display-address>no</display-address> <!-- see above for display rules, default ‘yes’ -->
  end
  xml.details do
    xml.price listing.price.to_i
    xml.tag!('property-type') { xml.text! zumper_property_type_for_export(listing.property_type.name) }
    xml.tag!('num-bedrooms') { xml.text! bed_for_export(listing.bed.name).to_s }
    xml.tag!('num-bathrooms') { xml.text! listing.full_baths_no.to_s }
    xml.tag!('num-half-bathrooms') { xml.text! listing.half_baths_no.to_s }
    xml.tag!('living-area-square-feet') { xml.text! listing.size.to_s }

    xml.description listing.description
    xml.tag!('provider-listingid') { xml.text! listing.id.to_s }
  end
  # todo: check if other needed
  xml.tag!('listing-type') { xml.text!(listing.listing_type.name == 'Rental' ? 'rental' : 'for sale') }
  xml.status zumper_status_for_export(listing.status.try(:name))

  xml.pictures do
    seq_no = 0
    listing.property_photos.each do |photo|
      xml.picture do
        xml.tag!('picture-url') { xml.text! photo.photo_url_url }
        xml.tag!('picture-seq-number') { xml.text! (seq_no += 1).to_s }
      end
    end
  end

  xml.agent do
    xml.tag!('agent-name') { xml.text! listing.user.name }
    xml.tag!('agent-phone') { xml.text! listing.user.phone }
    xml.tag!('agent-email') { xml.text! listing.user.email }
  end

  # todo: ask Peter
  xml.brokerage do
    xml.tag!('brokerage-name') { xml.text! '' }
    xml.tag!('brokerage-phone') { xml.text! '' }
    xml.tag!('brokerage-email') { xml.text! '' }
    xml.tag!('brokerage-website') { xml.text! '' }
  end
  xml.tag!('detailed-characteristics') do
    xml.appliances do
      if listing.dishwasher?
        xml.tag!('has-dishwasher') { xml.text! 'yes' }
      end
      if listing.gas?
        xml.tag!('range-type') { xml.text! 'gas' }
      end
    end
    if listing.parking_available?
      xml.tag!('has-assigned-parking-space') { xml.text! 'yes' }
    end
    if listing.balcony?
      xml.tag!('has-balcony') { xml.text! 'yes' }
    end
    if listing.yard?
      xml.tag!('has-courtyard') { xml.text! 'yes' }
    end
    if listing.patio?
      xml.tag!('has-private-patio') { xml.text! 'yes' }
    end
    if listing.elevator?
      xml.tag!('building-has-elevator') { xml.text! 'yes' }
    end

    xml.tag!('other-amenities') do
      if listing.laundry_in_building? or listing.laundry_in_unit?
        xml.tag!('other-amenity') { xml.text! 'laundry' }
      end
      if listing.storage_available?
        xml.tag!('other-amenity') { xml.text! 'storage' }
      end
    end
  end

  xml.tag!('rental-terms') do
    xml.pets do

      if listing.dogs?
        xml.tag!('small-dogs-allowed') { xml.text! 'yes' }
        xml.tag!(large-dogs-allowed) { xml.text! 'yes' }
      end
      if listing.cats?
        xml.tag!('cats-allowed') { xml.text! 'yes' }
      end
    end
  end

end

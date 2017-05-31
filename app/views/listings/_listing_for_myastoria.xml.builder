xml.property(id: listing.id, type: listing.listing_type.try(:name), status: listing.status.try(:name),
             created_at: listing.created_at.strftime('%y-%m-%d'),
             updated_at: listing.updated_at.strftime('%y-%m-%d')) do

  xml.location do
    xml.address listing.street_address
    xml.zipcode listing.zip_code
    xml.unit listing.unit_no
    xml.neighborhood listing.neighborhood.name
  end

  xml.details do
    xml.headline listing.title
    xml.price listing.price
    xml.bedrooms listing.bed.try :name
    xml.bathrooms listing.full_baths_no
    xml.halfbathrooms listing.half_baths_no
    xml.squareFeet listing.size
    xml.availableOn listing.available_date
    xml.description listing.description
    xml.propertyType listing.property_type.name
    xml.landlord listing.landlord
    xml.access listing.access

    xml.amenities do
      if listing.elevator?
        xml.elevator 'Elevator'
      end
      if listing.parking_available?
        xml.parking 'Parking available'
      end
      if listing.balcony?
        xml.balcony 'Balcony'
      end
      if listing.storage_available?
        xml.storage 'Storage'
      end
      if listing.patio?
        xml.patio 'Patio'
      end
      if listing.backyard?
        xml.backyard 'Backyard'
      end
      if listing.laundry_in_building?
        xml.laundaryinbuilding 'Laundry in building'
      end
      if listing.laundry_in_unit?
        xml.laundaryinunit 'Laundry in unit'
      end
      if listing.live_in_super?
        xml.liveinsuper 'Live-in super'
      end
      if listing.absentee_landlord?
        xml.absenteelandlord 'Absentee landlord'
      end
      if listing.walk_up?
        xml.walkup 'Walk up'
      end
      if listing.yard?
        xml.yard 'Yard'
      end
      if listing.dishwasher?
        xml.dishwasher 'Dishwasher'
      end
    end

    xml.pets do
      if listing.no_pets?
        xml.nopets 'No pets'
      end
      if listing.cats?
        xml.cats 'Cats'
      end
      if listing.dogs?
        xml.dogs 'Dogs'
      end
      if listing.approved_pets_only?
        xml.approvedpetsonly 'Approved pets only'
      end
    end

    xml.utilities do
      if listing.heat_and_hot_water?
        xml.heatandhotwater 'Heat and hot water'
      end
      if listing.gas?
        xml.gas 'Gas'
      end
      if listing.all_utilities?
        xml.all 'All'
      end
      if listing.none?
        xml.none 'None'
      end
    end
  end

  xml.agents do
    if listing.user.present?
      xml.agent(id: listing.user.id) do
        xml.name listing.user.name
        xml.email listing.user.email
        xml.phone_numbers do
          xml.main listing.user.phone
          xml.fax listing.user.fax
        end
      end
    end
  end

  xml.media do
    listing.property_photos.each do |photo|
      xml.photo(url: photo.photo_url_url) if photo.photo_url_url.present?
    end
    listing.property_floorplans.each do |floorplan|
      xml.floorplan(url: floorplan.floorplan_url_url) if floorplan.floorplan_url_url.present?
    end
    listing.property_videos.each do |video|
      xml.video(url: video.video_url) if video.video_url.present?
    end
  end
end

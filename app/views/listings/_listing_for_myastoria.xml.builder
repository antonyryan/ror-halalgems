  xml.property(id: listing.id, type: listing.listing_type.try(:name), status: listing.status.try(:name)) do

    xml.location do
      xml.address listing.street_address
      xml.zipcode listing.zip_code
      xml.unit listing.unit_no
      xml.neighborhood listing.neighborhood.name
    end

    xml.details do
      xml.price listing.price
      xml.bedrooms listing.bed.name
      xml.bathrooms listing.full_baths_no
      xml.halfbathrooms listing.half_baths_no
      xml.squareFeet listing.size
      xml.availableOn listing.available_date
      xml.description listing.description
      xml.propertyType listing.property_type.name
      xml.landlord listing.landlord

      xml.amenities do
        if listing.elevator?
          xml.elevator
        end
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
        if listing.backyard?
          xml.backyard
        end
        if listing.laundry_in_building?
          xml.laundaryinbuilding
        end
        if listing.laundry_in_unit?
          xml.laundaryinunit
        end
        if listing.live_in_super?
          xml.liveinsuper
        end
        if listing.absentee_landlord?
          xml.absenteelandlord
        end
        if listing.walk_up?
          xml.walkup
        end
        if listing.yard?
          xml.yard
        end
        if listing.dishwasher?
          xml.dishwasher
        end
      end

      xml.pets do
        if listing.no_pets?
          xml.nopets
        end
        if listing.cats?
          xml.cats
        end
        if listing.dogs?
          xml.dogs
        end
        if listing.approved_pets_only?
          xml.approvedpetsonly
        end
      end

      xml.utilities do
        if listing.heat_and_hot_water?
          xml.heatandhotwater
        end
        if listing.gas?
          xml.gas
        end
        if listing.all_utilities?
          xml.all
        end
        if listing.none?
          xml.none
        end
      end
    end

    xml.agents do
      xml.agent(id: listing.user.try(:id)) do
        xml.name listing.user.name
        xml.email listing.user.email
        xml.phone_numbers do
          xml.main listing.user.phone
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

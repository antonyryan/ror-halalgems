module ListingsHelper
	def link_to_add_fields(name, f, association)
		new_object = f.object.send(association).klass.new
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |builder|
			render(association.to_s.singularize + '_fields', f: builder)
		end
		link_to('', '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
	end

	def link_to_remove_fields(name, f)
    	f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def filter_check_box_tag(name, value = nil)
    check_box_tag name, (value unless value.blank?), (value != '0' unless value.blank?)
  end



  def sortable_link(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    ds = display_helper
    glyph =''
    if column == sort_column
      if direction == 'asc'
        glyph = tag 'i', class: "glyphicon glyphicon-arrow-up"
      else
        glyph = tag 'i', class: "glyphicon glyphicon-arrow-down"
      end
    end
    return link_to( title, { sort: column, direction: direction, display: ds } ) +' ' + glyph
  end

  def status_for_export(status)
    #active|off-market|temp-off-market|in-contract|contract-out|contract-signed|sold|rented
    if status == 'New'
      return 'active'
    end
    if status == 'Accepted offer'
      return 'active'
    end
    if status == 'Under contract'
      return 'in-contract'
    end
    if status == 'Price change'
      return 'active'
    end
    if status == 'Closed'
      return 'off-market'
    end
    if status == 'Temporary off market'
      return 'temp-off-market'
    end
    if status == 'Withdrawn'
      return 'active'
    end
    if status == 'Deposit/Pending Application'
      return 'temp-off-market'
    end
    if status == 'Lost'
      return 'off-market'
    end
    if status == 'Rented'
      return 'rented'
    end

    status
  end

  def bed_for_export(bed)
    if bed == 'Studio'
      return 0
    end
    if (bed == 'Junior 1') or (bed == '1 Bedroom') or (bed == '1 Bedroom plus den')
      return 1
    end

    if (bed == 'Junior 4') or (bed == '4 Bedroom')
      return 4
    end

    if (bed == '2 Bedroom') or (bed == '2 Bedroom plus den')
      return 2
    end

    if bed == '3 Bedroom'
      return 3
    end

    0
  end

  def property_type_for_export(property_type)
  #   condo|coop|townhouse|condop|rental|house|other
    if property_type == 'Private House'
      return 'house'
    end
    if property_type == 'Multi-family'
      return 'other'
    end
    if property_type == 'Coop'
      return 'coop'
    end
    if property_type == 'Condo'
      return 'condo'
    end
    'other'
  end
end

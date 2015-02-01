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
end

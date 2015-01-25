require 'open-uri'

red_color = "CE003D"
pdf.float do
  pdf.fill_color red_color
  x_pos = pdf.bounds.absolute_left - 10
  y_pos = pdf.bounds.absolute_top
  h = pdf.bounds.height
  pdf.canvas do
    pdf.fill_rectangle [x_pos, y_pos], 10, h

  end
  pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width,
                     pdf.height_of(@listing.full_address, :size => 30, :style => :italic)
  pdf.fill_color "#000000"
end
pdf.move_down 7
y_pos = pdf.cursor
pdf.text @listing.full_address, :size => 30, :style => :italic, color: "FFFFFF"

pdf.float do
  unless @listing.listing_type.nil?
    type_name = @listing.listing_type.name
    width = pdf.width_of( type_name ) +5
    height = pdf.height_of( type_name ) +5
    #pdf.fill_color "1AB3EA"
    pdf.fill_rounded_rectangle [pdf.bounds.right - width - 4, y_pos],
                               width, height, 5
    #pdf.fill_color "000000"
    pdf.bounding_box([pdf.bounds.right - width -2 , y_pos], width: width, height: height) do
      pdf.text type_name, color: "FFFFFF", valign: :center
    end
  end
end

y_pos = pdf.cursor
half = pdf.bounds.width/2
pdf.bounding_box([0, y_pos], width: half - 5) do
  pdf.text("Unit no: #{@listing.unit_no}") unless @listing.unit_no.nil? || @listing.unit_no.empty?
  pdf.text("Zip: #{@listing.zip_code}") unless @listing.zip_code.nil?
end

pdf.bounding_box([half+10, y_pos], width: half - 5) do
  pdf.text(@listing.property_type.name, color: red_color, align: :right) unless @listing.property_type.nil?
  pdf.text number_to_currency(@listing.price), style: :bold, color: red_color, align: :right
end

if @listing.property_photos.count > 0
  pdf.image open(@listing.property_photos.first.photo_url_url), width: pdf.bounds.width
end

pdf.move_down 10
pdf.text "#{@listing.bed.name} / #{@listing.full_baths_no} full baths / #{@listing.half_baths_no} half baths",
         size: 16, style: :italic
pdf.text @listing.description

pdf.move_down 10


y_pos = pdf.cursor
pdf.bounding_box([0, y_pos], width: half - 5) do
  pdf.text "<b>Agent:</b> #{@listing.user.name}", inline_format: true
  unless @listing.user.phone.blank?
    pdf.text "<b>Phone:</b> #{@listing.user.phone}", inline_format: true
  end

  unless @listing.user.email.blank?
    pdf.text "<b>Email:</b> #{@listing.user.email}", inline_format: true
  end
end

pdf.bounding_box( [half+10, y_pos], width: half - 5) do
  unless @listing.features.empty?
          pdf.text "<b>Features:</b> #{@listing.features}", inline_format: true
  end
  unless @listing.pets.empty?
    pdf.text "<b>Pets:</b> #{@listing.pets}", inline_format: true
  end
  unless @listing.utilities.empty?
    pdf.text "<b>Utilities:</b> #{@listing.utilities}", inline_format: true
  end
end

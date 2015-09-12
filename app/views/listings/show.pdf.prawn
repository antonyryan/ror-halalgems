require 'open-uri'
require "prawn/measurement_extensions"

pdf.font_families.update('OpenSans' => {
                             normal: "#{Rails.root.join('vendor', 'assets', 'fonts')}/OpenSans-Regular.ttf",
                             italic: "#{Rails.root.join('vendor', 'assets', 'fonts')}/OpenSans-Italic.ttf",
                             bold: "#{Rails.root.join('vendor', 'assets', 'fonts')}/OpenSans-Semibold.ttf",
                             bold_italic: "#{Rails.root.join('vendor', 'assets', 'fonts')}/OpenSans-SemiboldItalic.ttf"
                         })
pdf.font('OpenSans')
blue_color = '0095DA'
pdf.float do
  pdf.image "#{Rails.root}/app/assets/images/logo.png"
end

y_pos = pdf.cursor
type_name = (@listing.listing_type.try :name || 'none').upcase
price = number_to_currency(@listing.price)

width = 160 #pdf.width_of(type_name, size: 16, :styles => [:normal])

price_height = pdf.height_of(price, :size => 24, style: :bold)
type_height = pdf.height_of(type_name, :size => 16)
height = price_height + type_height + 20

pdf.bounding_box([0, y_pos], width: pdf.bounds.width, height: height) do
  # pdf.stroke_bounds
  pdf.text @listing.full_address, :size => 24, style: :bold, :valign => :bottom


  pdf.fill_color blue_color
  pdf.fill_rectangle [pdf.bounds.right - width, height], width, height

  pdf.text price, color: 'FFFFFF', :size => 24, style: :bold, :valign => :bottom, align: :right

  pdf.bounding_box([pdf.bounds.right - width + 5, height - 5], width: width - 5) do
    pdf.text type_name, color: 'FFFFFF', :size => 12
  end
end
pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width, 6
pdf.fill_color '#000000'

pdf.move_down 8
pdf.text((@listing.property_type.present? ? @listing.property_type.name : '') +
             (@listing.unit_no.present? ? " / Unit no: #{@listing.unit_no}" : ''), size: 10)
pdf.move_down 2

main_y_pos = pdf.cursor
gap = 15
firs_width = pdf.bounds.width * 0.75
second_width = pdf.bounds.width * 0.25 - gap

pdf.fill_color 'eeeeee'
pdf.bounding_box([0, main_y_pos], width: firs_width, height: 480) do
  small_width = (pdf.bounds.width - 2 * gap) / 3
  small_height = (pdf.bounds.height - 280 - 2 * gap) / 2
  images = @listing.property_photos.to_a
  images_count = images.size

  pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: 280) do
    pdf.fill_rectangle [0, pdf.bounds.height], pdf.bounds.width, pdf.bounds.height
    if images_count > 0 and images[0].photo_url_url.present?
      pdf.image open(images[0].photo_url_url), fit: [pdf.bounds.width, pdf.bounds.height], position: :center
    end
  end
  y_pos = pdf.cursor
  pdf.bounding_box([0, y_pos - gap], width: small_width, height: small_height) do
    pdf.fill_rectangle [0, pdf.bounds.height], pdf.bounds.width, pdf.bounds.height
    if images_count > 1 and images[1].photo_url_url.present?
      pdf.image open(images[1].photo_url_url), fit: [pdf.bounds.width, pdf.bounds.height], position: :center
    end
  end
  pdf.bounding_box([small_width + gap, y_pos - gap], width: small_width, height: small_height) do
    pdf.fill_rectangle [0, pdf.bounds.height], pdf.bounds.width, pdf.bounds.height
    if images_count > 2 and images[2].photo_url_url.present?
      pdf.image open(images[2].photo_url_url), fit: [pdf.bounds.width, pdf.bounds.height], position: :center
    end
  end
  pdf.bounding_box([2*small_width + 2 * gap, y_pos - gap], width: small_width, height: small_height) do
    pdf.fill_rectangle [0, pdf.bounds.height], pdf.bounds.width, pdf.bounds.height
    if images_count > 3 and images[3].photo_url_url.present?
      pdf.image open(images[3].photo_url_url), fit: [pdf.bounds.width, pdf.bounds.height], position: :center
    end
  end

  y_pos = pdf.cursor
  pdf.bounding_box([0, y_pos - gap], width: small_width, height: small_height) do
    pdf.fill_rectangle [0, pdf.bounds.height], pdf.bounds.width, pdf.bounds.height
    if images_count > 4 and images[4].photo_url_url.present?
      pdf.image open(images[4].photo_url_url), fit: [pdf.bounds.width, pdf.bounds.height], position: :center
    end
  end
  pdf.bounding_box([small_width + gap, y_pos - gap], width: small_width, height: small_height) do
    pdf.fill_rectangle [0, pdf.bounds.height], pdf.bounds.width, pdf.bounds.height
    if images_count > 5 and images[5].photo_url_url.present?
      pdf.image open(images[5].photo_url_url), fit: [pdf.bounds.width, pdf.bounds.height], position: :center
    end
  end
  pdf.bounding_box([2*small_width + 2 * gap, y_pos - gap], width: small_width, height: small_height) do
    pdf.fill_rectangle [0, pdf.bounds.height], pdf.bounds.width, pdf.bounds.height
    if images_count > 6 and images[6].photo_url_url.present?
      pdf.image open(images[6].photo_url_url), fit: [pdf.bounds.width, pdf.bounds.height], position: :center
    end
  end
end
pdf.fill_color '000000'

pdf.bounding_box([firs_width + gap, main_y_pos], width: second_width, height: 480) do
pdf.default_leading 4

  pdf.text 'Residence Information', color: blue_color, :size => 10, style: :bold
  pdf.text "#{@listing.bed.name}, #{@listing.full_baths_no} full baths, #{@listing.half_baths_no} half baths", :size => 10, style: :bold

  pdf.move_down 5
  pdf.text 'Features', color: blue_color, :size => 10, style: :bold
  pdf.text @listing.features, :size => 10, style: :bold

  pdf.move_down 5
  pdf.text 'Pets', color: blue_color, :size => 10, style: :bold
  pdf.text @listing.pets, :size => 10, style: :bold

  pdf.move_down 5
  pdf.text 'Utilities', color: blue_color, :size => 10, style: :bold
  pdf.text @listing.utilities, :size => 10, style: :bold

  pdf.move_down 5
  pdf.text_box (@listing.description || ""), at: [0, pdf.cursor], height: pdf.cursor,  :size => 10
end

pdf.move_down gap
y_pos = pdf.cursor
bottom_left_width = ((firs_width - 2*gap)/3)*2+gap
pdf.bounding_box([0, pdf.cursor], width: bottom_left_width, height: 140) do
  map_url = "http://maps.googleapis.com/maps/api/staticmap?zoom=15&center=#{URI.encode(@listing.full_address)}&size=#{(pdf.bounds.width).to_i}x#{(pdf.bounds.height).to_i}"
  pdf.image open(map_url)
end

pdf.bounding_box([bottom_left_width + gap, y_pos], width: pdf.bounds.width - bottom_left_width - gap, height: 140) do
  pdf.fill_color 'eeeeee'
  pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width, pdf.bounds.height

  start_y = pdf.cursor

  pdf.fill_color 'facd40'
  pdf.fill_polygon [-4, start_y], [80, start_y], [70, start_y - 10], [80, start_y - 20], [-4, start_y - 20]

  pdf.fill_color '463706'
  pdf.fill_polygon [-4, start_y - 20], [0, start_y - 20], [0, start_y - 24]

  pdf.fill_color '000000'
  pdf.formatted_text_box [{text: 'AGENT', color: 'FFFFFF'}], at: [10, start_y - 4], :size => 14, style: :bold

  pdf.move_down 35
  pdf.text @listing.user.name, size: 16, style: :bold, :indent_paragraphs => 10

  pdf.move_down 8
  pdf.text 'Phone', color: blue_color, :size => 10, style: :bold, :indent_paragraphs => 10
  pdf.text @listing.user.phone, :size => 10, style: :bold, :indent_paragraphs => 10

  pdf.move_down 8
  pdf.text 'Email', color: blue_color, :size => 10, style: :bold, :indent_paragraphs => 10
  pdf.text @listing.user.email, :size => 10, style: :bold, :indent_paragraphs => 10

  if @listing.user.avatar_url.present?
    pdf.bounding_box([pdf.bounds.width / 2 + gap, 140], width: pdf.bounds.width / 2 - gap, height: 140) do
      pdf.stroke_bounds
      # pdf.image open("http://res.cloudinary.com/hpmowmbqq/image/upload/v1422469666/mqjuntllqlhfex6847br.jpg"), fit: [pdf.bounds.width, pdf.bounds.height]
      pdf.image open(@listing.user.avatar_url), fit: [pdf.bounds.width, pdf.bounds.height]
    end
  end
end

# pdf.text @listing.full_address, :size => 24, style: :bold
#
# pdf.fill_color blue_color
# pdf.float do
#   type_name = @listing.listing_type.try :name || 'none'
#   price = number_to_currency(@listing.price)
#   width = pdf.width_of(type_name, size: 16, :styles => [:normal])
#
#   # height = pdf.height_of_formatted(
#   #     [
#   #         {:text => type_name, size: 16, :styles => [:normal]},
#   #         {:text => price, :size => 24, :styles => [:bold]}
#   #     ]
#   # )
#
#   price_height = pdf.height_of(price, :size => 24, style: :bold)
#   type_height = pdf.height_of(type_name, :size => 16)
#   height = price_height + type_height
#
#   pdf.fill_rectangle [pdf.bounds.right - width, y_pos], width, height
#   #pdf.fill_color "000000"
#   pdf.bounding_box([pdf.bounds.right - width, y_pos], width: width, height: height) do
#     pdf.text type_name, color: 'FFFFFF', :size => 16
#     pdf.text price, color: 'FFFFFF', :size => 24, style: :bold
#   end
# end

#

# red_color = 'CE003D'
# pdf.float do
#   pdf.fill_color red_color
#   x_pos = pdf.bounds.absolute_left - 10
#   y_pos = pdf.bounds.absolute_top
#   h = pdf.bounds.height
#   pdf.canvas do
#     pdf.fill_rectangle [x_pos, y_pos], 10, h
#
#   end
#   pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width,
#                      pdf.height_of(@listing.full_address, :size => 30, :style => :italic)
#   pdf.fill_color "#000000"
# end
# pdf.move_down 7
# y_pos = pdf.cursor
# pdf.text @listing.full_address, :size => 30, :style => :italic, color: "FFFFFF"
#
# pdf.float do
#   unless @listing.listing_type.nil?
#     type_name = @listing.listing_type.name
#     width = pdf.width_of( type_name ) +5
#     height = pdf.height_of( type_name ) +5
#     #pdf.fill_color "1AB3EA"
#     pdf.fill_rounded_rectangle [pdf.bounds.right - width - 4, y_pos],
#                                width, height, 5
#     #pdf.fill_color "000000"
#     pdf.bounding_box([pdf.bounds.right - width -2 , y_pos], width: width, height: height) do
#       pdf.text type_name, color: "FFFFFF", valign: :center
#     end
#   end
# end
#
# y_pos = pdf.cursor
# half = pdf.bounds.width/2
# pdf.bounding_box([0, y_pos], width: half - 5) do
#   pdf.text("Unit no: #{@listing.unit_no}") unless @listing.unit_no.nil? || @listing.unit_no.empty?
#   pdf.text("Zip: #{@listing.zip_code}") unless @listing.zip_code.nil?
# end
#
# pdf.bounding_box([half+10, y_pos], width: half - 5) do
#   pdf.text(@listing.property_type.name, color: red_color, align: :right) unless @listing.property_type.nil?
#   pdf.text number_to_currency(@listing.price), style: :bold, color: red_color, align: :right
# end
#
# if @listing.property_photos.count > 0
#   pdf.image open(@listing.property_photos.first.photo_url_url), width: pdf.bounds.width
# end
#
# pdf.move_down 10
# pdf.text "#{@listing.bed.name} / #{@listing.full_baths_no} full baths / #{@listing.half_baths_no} half baths",
#          size: 16, style: :italic
# pdf.text @listing.description
#
# pdf.move_down 10
#
#
# y_pos = pdf.cursor
# pdf.bounding_box([0, y_pos], width: half - 5) do
#   pdf.text "<b>Agent:</b> #{@listing.user.name}", inline_format: true
#   unless @listing.user.phone.blank?
#     pdf.text "<b>Phone:</b> #{@listing.user.phone}", inline_format: true
#   end
#
#   unless @listing.user.email.blank?
#     pdf.text "<b>Email:</b> #{@listing.user.email}", inline_format: true
#   end
# end
#
# pdf.bounding_box( [half+10, y_pos], width: half - 5) do
#   unless @listing.features.empty?
#           pdf.text "<b>Features:</b> #{@listing.features}", inline_format: true
#   end
#   unless @listing.pets.empty?
#     pdf.text "<b>Pets:</b> #{@listing.pets}", inline_format: true
#   end
#   unless @listing.utilities.empty?
#     pdf.text "<b>Utilities:</b> #{@listing.utilities}", inline_format: true
#   end
# end

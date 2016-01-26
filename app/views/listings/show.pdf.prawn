require 'open-uri'
require 'prawn/measurement_extensions'

pdf.font_families.update('OpenSans' => {
                             normal: "#{Rails.root.join('vendor', 'assets', 'fonts')}/OpenSans-Regular.ttf",
                             italic: "#{Rails.root.join('vendor', 'assets', 'fonts')}/OpenSans-Italic.ttf",
                             bold: "#{Rails.root.join('vendor', 'assets', 'fonts')}/OpenSans-Semibold.ttf",
                             bold_italic: "#{Rails.root.join('vendor', 'assets', 'fonts')}/OpenSans-SemiboldItalic.ttf"
                         })
pdf.font('OpenSans')

blue_color = '0095DA'
black_color = '444444'

pdf.fill_color black_color

pdf.float do
  pdf.image "#{Rails.root}/app/assets/images/logo.png", scale: 0.25
end

gap = 15
firs_width = pdf.bounds.width * 0.75
second_width = pdf.bounds.width * 0.25 - gap

y_pos = pdf.cursor
type_name = (@listing.listing_type.try :name || 'none').upcase
price = "$#{@listing.price.to_i}"

blue_box_width = second_width #pdf.width_of(type_name, size: 16, :styles => [:normal])
title_box_width = pdf.bounds.width - blue_box_width

price_height = pdf.height_of(price, :size => 24, style: :bold)
type_height = pdf.height_of(type_name, :size => 16)
height = price_height + type_height + 20

price_width = pdf.width_of(price, size: 24, :styles => [:bold])
ident = (blue_box_width - price_width) / 2
title_height =40# pdf.height_of(@listing.headline, :size => 24, style: :bold)

pdf.bounding_box([0, y_pos], width: pdf.bounds.width, height: height) do
  # pdf.stroke_bounds
  pdf.text_box @listing.headline, at: [0, title_height], width: title_box_width, height: title_height,
               overflow: :shrink_to_fit, :size => 24, style: :bold, :valign => :bottom

  pdf.fill_color blue_color
  pdf.fill_rectangle [pdf.bounds.right - blue_box_width, height], blue_box_width, height


  pdf.bounding_box([pdf.bounds.right - blue_box_width, height - 10], width: blue_box_width, height: height - 10) do
    pdf.indent(ident) do
      pdf.text type_name, color: 'FFFFFF', :size => 12
      pdf.fill_color 'ffffff'
      pdf.text_box price, at: [0, price_height], width: pdf.bounds.width, height: price_height, :size => 24,
                   style: :bold, :valign => :bottom, owerflow: :truncate
    end
  end
end

pdf.fill_color blue_color
pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width, 5
pdf.fill_color black_color

pdf.move_down 10
pdf.text((@listing.property_type.present? ? @listing.property_type.name : '') +
             (@listing.unit_no.present? ? " / Unit no: #{@listing.unit_no}" : ''), size: 10)
pdf.move_down 10

main_y_pos = pdf.cursor

pdf.fill_color 'ffffff'
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
  pdf.fill_color 'eeeeee'
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
pdf.fill_color black_color

pdf.bounding_box([firs_width + gap, main_y_pos], width: second_width, height: 480) do
  pdf.default_leading 4
  pdf.font('OpenSans', :size => 11, style: :bold) do
    pdf.text 'Residence Information', color: blue_color
    pdf.text "#{@listing.bed.try :name}, #{@listing.full_baths_no} full baths, #{@listing.half_baths_no} half baths"

    pdf.move_down 5
    pdf.text 'Features', color: blue_color
    pdf.text @listing.features

    pdf.move_down 5
    pdf.text 'Pets', color: blue_color
    pdf.text @listing.pets

    pdf.move_down 5
    pdf.text 'Utilities', color: blue_color
    pdf.text @listing.utilities
  end

  pdf.move_down 5
  pdf.text_box (@listing.description || ''), at: [0, pdf.cursor], height: pdf.cursor,  :size => 10

  pdf.default_leading 0
end

pdf.move_down gap
y_pos = pdf.cursor
bottom_left_width = ((firs_width - 2*gap)/3)*2+gap
pdf.bounding_box([0, pdf.cursor], width: bottom_left_width, height: 140) do
  map_url = "http://maps.googleapis.com/maps/api/staticmap?zoom=15&center=#{URI.encode(@listing.full_address)}&size=#{(pdf.bounds.width).to_i}x#{(pdf.bounds.height).to_i}&markers=#{URI.encode(@listing.full_address)}"
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

  pdf.fill_color black_color
  pdf.formatted_text_box [{text: 'AGENT', color: 'FFFFFF'}], at: [10, start_y - 4], :size => 14, style: :bold

  pdf.move_down 30
  pdf.text_box current_user.name, at: [10, pdf.cursor], width: 130, height: 25, size: 16, style: :bold, overflow: :shrink_to_fit

  pdf.move_down 25
  pdf.text current_user.license_type, size: 9, :indent_paragraphs => 10

  pdf.default_leading 2
  pdf.move_down 8
  pdf.text 'Phone', color: blue_color, :size => 11, style: :bold, :indent_paragraphs => 10
  pdf.text current_user.phone, :size => 11, style: :bold, :indent_paragraphs => 10


  pdf.text 'Email', color: blue_color, :size => 11, style: :bold, :indent_paragraphs => 10

  email_height = pdf.height_of(current_user.email, :size => 11, style: :bold)
  pdf.text_box current_user.email, at: [10, pdf.cursor], width: 130, height: email_height+5,  :size => 11, style: :bold,
               overflow: :shrink_to_fit
  pdf.default_leading 0
  if current_user.avatar.present?
    pdf.bounding_box([pdf.bounds.width / 2 + gap, 140], width: pdf.bounds.width / 2 - gap, height: 140) do
      # pdf.image open("http://res.cloudinary.com/hpmowmbqq/image/upload/v1422469666/mqjuntllqlhfex6847br.jpg"), fit: [pdf.bounds.width, pdf.bounds.height]
      pdf.image open(current_user.avatar_url), fit: [pdf.bounds.width, pdf.bounds.height]
    end
  end
end
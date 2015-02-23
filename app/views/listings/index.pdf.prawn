items = @listings.map do |listing|
  [
    listing.street_address,
    listing.unit_no,
    listing.neighborhood.try( :name ),
    listing.bed.try(:name),
    number_to_currency(listing.price),
    listing.available_date,
    listing.user.try(:name)
  ]
end
items.unshift ['Street address', 'Unit', 'Neighborhood', 'Beds', "Price", 'Available date', 'Agent']

pdf.table(items, cell_style: {size: 10}) do
  row(0).background_color = "DDDDDD"
  column(3..4).align = :right
end

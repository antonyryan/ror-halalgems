xml.instruct!
xml.properties do
  @listings.each do |listing|
    xml << render(partial: 'listing', locals: {listing: listing})
  end
end
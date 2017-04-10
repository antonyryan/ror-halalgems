xml.instruct!
if params[:to].to_s.downcase == 'streeteasy'
  xml.streeteasy(version: '1.6') do
    xml.properties do
      @listings.each do |listing|
        xml << render(partial: 'listing', locals: {listing: listing})
      end
    end
  end
else
  xml.properties do
    @listings.each do |listing|
      xml << render(partial: 'listing', locals: {listing: listing})
    end
  end
end

class AgentMailer < ActionMailer::Base
  default from: "app30770416@heroku.com"

  def listing_changed(listing, old_status, new_status)
  	@listing = listing
    @old_status = old_status
    @new_status = new_status
  	mail(to: User.pluck(:email), subject: 'Listing status has been changed')
  end

  def listing_created(listing)
    @listing = listing
    mail(to: User.pluck(:email), subject: 'Listing has been created')
  end
end

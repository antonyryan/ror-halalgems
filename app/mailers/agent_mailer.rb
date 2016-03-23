class AgentMailer < ActionMailer::Base
  default from: "app30770416@heroku.com"

  def listing_changed(listing, old_status, new_status, agent)
  	@listing = listing
    @old_status = old_status
    @new_status = new_status
  	mail(from: agent.email, to: User.active_users.pluck(:email), subject: 'Listing status has been changed')
  end

  def listing_created(listing, agent)
    @listing = listing
    mail(from: agent.email, to: User.active_users.pluck(:email), subject: 'Listing has been created')
  end
end

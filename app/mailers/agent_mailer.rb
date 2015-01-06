class AgentMailer < ActionMailer::Base
  default from: "app30770416@heroku.com"

  def listing_changed(listing, agent)
  	@listing = listing
  	mail(to: agent.email, subject: 'listing has been changed')
  end
end

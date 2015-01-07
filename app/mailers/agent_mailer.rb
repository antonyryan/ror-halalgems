class AgentMailer < ActionMailer::Base
  default from: "app30770416@heroku.com"

  def listing_changed(listing, agents)
  	@listing = listing
  	agents.each do |agent|
  		mail(to: agent.email, subject: 'listing has been changed')
  	end
  end
end

class ListingMailer < ActionMailer::Base
  default from: 'app30770416@heroku.com'

  def client(email, listings, user_id)
    @listings = listings
    @agent = User.find user_id
    mail(from: @agent.email, to: email, subject: 'Listings', cc: @agent.email, reply_to: @agent.email)
  end
end

include ApplicationHelper

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara as well.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
    visit signin_path
    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password
    click_button "Sign in"
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end


def authenticate(username, password)
  if page.driver.browser.respond_to?(:authorize)
    # When headless
    page.driver.browser.authorize(username, password)
  else
    # When javascript test
    visit "http://#{username}:#{password}@#{host}:#{port}/"
  end
end


def host
  Capybara.current_session.server.host
end

def port
  Capybara.current_session.server.port
end

require 'selenium-webdriver'
require 'rails_helper'

RSpec.describe 'Login Page Test' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.navigate.to 'http://localhost:3000/' # Replace with the appropriate URL for your app
  end

  after(:all) do
    # Quit the driver after tests are complete
    @driver.quit
  end

  it 'displays the main heading' do
    heading = @driver.find_element(:tag_name, 'h1')
    expect(heading.text).to eq('JIMMY')
  end

  it 'displays the subtitle' do
    subtitle = @driver.find_element(:css, '.subtitle')
    expect(subtitle.text).to eq('Your Gym Buddies Finder')
  end

  it 'displays the login image' do
    image = @driver.find_element(:css, '.login-image')
    expect(image.attribute('src')).to include('login')
  end

  it 'has a login with Google button and redirects correctly' do
    button = @driver.find_element(:tag_name, 'button')

    expect(button.text).to eq('Login with Google')

    button.click
    sleep 2 # Allow some time for the page to redirect
    expect(@driver.current_url).to include('https://accounts.google.com/v3/signin/identifier')
  end
end

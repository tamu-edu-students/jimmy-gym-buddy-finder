Given('I am on the login page') do
  visit root_path  # Replace with your actual login page path
end

Then('I should see the main heading {string}') do |heading_text|
  expect(page).to have_css('h1.main-heading', text: heading_text)
end

Then('I should see the subtitle {string}') do |subtitle_text|
  expect(page).to have_css('p.subtitle', text: subtitle_text)
end

Then('I should see an image with the alt text {string}') do |alt_text|
  expect(page).to have_css("img[alt='#{alt_text}']")
end

Then('I should see a button labeled {string}') do |button_text|
  expect(page).to have_button(button_text)
end

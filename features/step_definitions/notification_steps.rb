Given("the prospective user has already matched with me") do
    UserMatch.create!(user_id: @prospective_user.id, prospective_user_id: @user.id, status: "matched")
  end
  
  Then("a notification should be created for the user who matched") do
    notification_for_user = Notification.find_by(user: @user, matched_user: @prospective_user)
  
    expect(notification_for_user).to be_present
    expect(notification_for_user.read).to eq(false)
  end

Given("I have an unread notification") do
    @notification = FactoryBot.create(:notification, user: @user, read: false)
  end
  
  When("I mark the notification as read") do
    page.driver.post "/users/#{@user.id}/notifications/#{@notification.id}/mark_as_read.json"
  end
  
  Then("the notification should be marked as read") do
    @notification.reload
    expect(@notification.read).to be true
  end
  
  Then("I should see a JSON response confirming the change") do
    response_body = JSON.parse(page.body)
    expect(response_body["id"]).to eq(@notification.id)
    expect(response_body["read"]).to eq(true)
  end

Given("I have a read notification") do
    @notification = FactoryBot.create(:notification, user: @user, read: true)
  end
  
  When("I mark the notification as unread") do
    page.driver.post "/users/#{@user.id}/notifications/#{@notification.id}/mark_as_unread.json"
  end
  
  Then("the notification should be marked as unread") do
    @notification.reload
    expect(@notification.read).to be false
  end
  
  
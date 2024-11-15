

  Given("I have a matched user") do
    @matched_user = FactoryBot.create(:user, :complete_profile)
    @match = UserMatch.create!(
      user_id: @user.id,
      prospective_user_id: @matched_user.id,
      status: "matched"
    )
    UserMatch.create!(
      user_id: @matched_user.id,
      prospective_user_id: @user.id,
      status: "matched"
    )
  end

  Given("I start a conversation with the matched user") do
    @conversation = Conversation.create!(
      user1: @user,
      user2: @matched_user
    )
  end

  Given("I am on the conversation page") do
    visit conversation_path(@conversation, user_id: @user.id)

    # Debug output
    puts "\nPage details:"
    puts "Current path: #{current_path}"
    puts "Conversation ID in test: #{@conversation.id}"
    puts "Form action: #{find('#new-message-form')['action']}"
  end

  When("I create a new message with content {string}") do |content|
    # Debug current state
    puts "\nCreating message:"
    puts "User ID: #{@user.id}"
    puts "Conversation ID: #{@conversation.id}"

    # Fill in the form
    within('#new-message-form') do
      fill_in 'message[content]', with: content
    end

    # Submit using JavaScript to handle Turbo
    page.execute_script(<<~JS)
      const form = document.getElementById('new-message-form');
      const formData = new FormData(form);

      fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        },
        credentials: 'same-origin'
      }).then(response => response.json())
      .then(data => {
        console.log('Success:', data);
      })
      .catch((error) => {
        console.error('Error:', error);
      });
    JS

    # Wait for AJAX completion
    sleep(2)
  end

  Then("the message should be saved to the database") do
    # Debug database state
    puts "\nDatabase state:"
    puts "All messages: #{Message.all.map { |m| "ID: #{m.id}, Content: #{m.content}, User: #{m.user_id}, Conversation: #{m.conversation_id}" }}"
    puts "All conversations: #{Conversation.all.map { |c| "ID: #{c.id}, User1: #{c.user1_id}, User2: #{c.user2_id}" }}"

    message = Message.last
    expect(message).to be_present
    expect(message.content).to eq("Hello, Gym Buddy!")
  end

  Then("I should see the message in the conversation") do
    within("#messages") do
      expect(page).to have_content("Hello, Gym Buddy!")
    end
  end

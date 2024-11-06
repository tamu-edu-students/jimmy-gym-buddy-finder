require "test_helper"

class BuddiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get buddies_index_url
    assert_response :success
  end
end

require 'test_helper'

class ManageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manage_index_url
    assert_response :success
  end

end

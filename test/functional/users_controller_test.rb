require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get all" do
    get :all
    assert_response :success
  end

  test "should get find" do
    get :find
    assert_response :success
  end

end

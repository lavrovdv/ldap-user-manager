require 'test_helper'

class ChangePasswordControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get change_pass" do
    get :change_pass
    assert_response :success
  end

end
